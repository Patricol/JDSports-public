"""
All documentation, all comments, some functions, and some static variables have been REDACTED from this public version.
"""

import sys, JDSBasic
sys.excepthook = JDSBasic.NoCloseFail
import time
import os
import datetime
import pickle
import JDSEmails
import JDSWalmartAPI
from JDSEmailTypes import WalmartRefunder_Compliant_OrderEmail as OrderEmail
from JDSEmailTypes import WalmartRefunder_Compliant_UpdateEmail as UpdateEmail
from JDSEmailTypes import WalmartRefunder_Compliant_RefundRequestEmail as RefundRequestEmail
from JDSEmailTypes import WalmartRefunder_Compliant_DebugRefundRequestEmail as DebugRefundRequestEmail
from distutils.util import strtobool
from JDSBasic import minutes_ago, days_ago


DATA_FORMAT_VERSION = "3 (9/24/2017)"

DOLLAR_THRESHOLD_FOR_REFUND_REQUEST = 3
MINUTES_BETWEEN_SAVING_DATA = 20
EXPORT_ONLY = False
already_asked_about_api_pull = False

DebugMode = False
SKIP_TO_DEBUG_RUNS = False

if DebugMode:
    DATA_FILE_PATH = "{}\\WalmartRefunder Saved Data (Debug)".format(os.getcwd())
    EMAIL_TO_SEND_TO = "REDACTED"
    EMAILS_TO_SEND_PER_DAY = 960
    SECONDS_TO_WAIT_BETWEEN_CHECKING_FOR_NEW_EMAILS_IF_NONE_SENT = 30
    DAYS_OLD_TO_JUSTIFY_API_CHECK = 10
else:
    EMAIL_TO_SEND_TO = "help@walmart.com"
    DATA_FILE_PATH = "{}\\WalmartRefunder Saved Data".format(os.getcwd())
    EMAILS_TO_SEND_PER_DAY = 16
    SECONDS_TO_WAIT_BETWEEN_CHECKING_FOR_NEW_EMAILS_IF_NONE_SENT = 300
    DAYS_OLD_TO_JUSTIFY_API_CHECK = 10

if DebugMode:
    print("DEBUG MODE ENABLED FOR WalmartRefunder! DO NOT SHIP THIS VERSION!")
    LOAD_EXISTING_FILE = True
    PULL_SMALL_SET = not LOAD_EXISTING_FILE
    STILL_LOOP = True
    if PULL_SMALL_SET:
        DAYS_TO_CHECK_IN_DEBUG = 10



class WalmartOrderItem:
    
    def __init__(self, WalmartOrder_item_data):
        [self.walmartid,
         self.name,
         self.initial_price_paid,
         self.quantity,
         self._current_price_paid,
         self._current_known_price,
         self._current_known_stock,
         self._current_known_sold_by_walmart,
         self._known_is_clearance] = self._convert_WalmartOrder_item_data_to_standard_data(WalmartOrder_item_data)
    
    def __repr__(self):
        return "WalmartID#{} Qty:{} Paid:{} Current:{} Name:{}".format(self.walmartid, self.quantity, self._current_price_paid, self._current_known_price, self.name)
    
    def _check_if_data_is_standard(self, walmartid=None, name=None, initial_price_paid=None, quantity=None, price_paid=None, price=None, stock=None, sold_by_walmart=None, known_is_clearance=None):
        strings = [walmartid, name]
        floats = [initial_price_paid, price_paid, price]
        ints = [quantity]
        bools = [stock, sold_by_walmart, known_is_clearance]
        assertion_base_string = "Type of var: {}\nRepr of var: {}\nTo help find which it is in the list: {}"
        for var in strings:
            assert var is None or isinstance(var, str), assertion_base_string.format(str(type(var)), repr(var), [(var is x) for x in strings])
        for var in floats:
            assert var is None or isinstance(var, float), assertion_base_string.format(str(type(var)), repr(var), [(var is x) for x in floats])
        for var in ints:
            assert var is None or isinstance(var, int), assertion_base_string.format(str(type(var)), repr(var), [(var is x) for x in ints])
        for var in bools:
            assert var is None or isinstance(var, bool), assertion_base_string.format(str(type(var)), repr(var), [(var is x) for x in bools])
    
    def _convert_WalmartOrder_item_data_to_standard_data(self, WalmartOrder_item_data):
        walmartid = WalmartOrder_item_data["walmartid"]
        name = WalmartOrder_item_data["name"]
        initial_price_paid = WalmartOrder_item_data["price"]
        quantity = WalmartOrder_item_data["quantity"]
        price_paid = initial_price_paid
        price = initial_price_paid
        stock = True
        sold_by_walmart = WalmartOrder_item_data["shipped_from_walmart"]
        known_is_clearance = False
        self._check_if_data_is_standard(walmartid=walmartid, name=name, initial_price_paid=initial_price_paid, quantity=quantity, price_paid=price_paid, price=price, stock=stock, sold_by_walmart=sold_by_walmart, known_is_clearance=known_is_clearance)
        return [walmartid, name, initial_price_paid, quantity, price_paid, price, stock, sold_by_walmart, known_is_clearance]
    
    def _convert_UpdateEmail_data_to_standard_data(self, WalmartUpdate_object):
        price = WalmartUpdate_object.get_price()
        stock = WalmartUpdate_object.get_stock()
        sold_by_walmart = WalmartUpdate_object.get_sold_by_walmart()
        self._check_if_data_is_standard(price=price, stock=stock, sold_by_walmart=sold_by_walmart)
        return [price, stock, sold_by_walmart]
    
    def _process_bool_from_api(self, bool_from_api):
        if not type(bool_from_api) is bool:
            if isinstance(bool_from_api, str) and bool_from_api.startswith("Failed"):
                bool_from_api = None
            else:
                converted = bool(strtobool(bool_from_api))
                if DebugMode and not str(bool_from_api) == str(converted):
                    print("Converting {} to {}.".format(bool_from_api, converted))
                bool_from_api = converted
        return bool_from_api
    
    def _convert_api_data_to_standard_data(self, JDSWalmartAPI_WalmartData_Object):
        price = JDSWalmartAPI_WalmartData_Object.get_price()
        try:
            price = float(price)
        except:
            if DebugMode and not (isinstance(price, str) and price.startswith("Failed")):
                print("Error with API-pulled price for {}. Price was {}".format(self.walmartid, JDSWalmartAPI_WalmartData_Object.get_price()))
            price = None
        stock = self._process_bool_from_api(JDSWalmartAPI_WalmartData_Object.get_stock())
        sold_by_walmart = self._process_bool_from_api(JDSWalmartAPI_WalmartData_Object.get_sold_by_walmart())
        clearance = self._process_bool_from_api(JDSWalmartAPI_WalmartData_Object.get_clearance())
        self._check_if_data_is_standard(price=price, stock=stock, sold_by_walmart=sold_by_walmart, known_is_clearance=clearance)
        return [price, stock, sold_by_walmart, clearance]
    
    def _update(self, new_price=None, new_stock=None, new_sold_by_walmart=None, new_price_paid=None, known_is_clearance=None):
        self._check_if_data_is_standard(price=new_price, stock=new_stock, sold_by_walmart=new_sold_by_walmart, price_paid=new_price_paid, known_is_clearance=known_is_clearance)
        if new_price is not None:
            self._current_known_price = new_price
        if new_stock is not None:
            self._current_known_stock = new_stock
        if new_sold_by_walmart is not None:
            self._current_known_sold_by_walmart = new_sold_by_walmart
        if new_price_paid is not None:
            self._current_price_paid = new_price_paid
        if known_is_clearance is not None:
            self._known_is_clearance = known_is_clearance
        else:
            self._known_is_clearance = False
    
    def update_from_UpdateEmail_data(self, WalmartUpdate_object):
        [new_price, new_stock, new_sold_by_walmart] = self._convert_UpdateEmail_data_to_standard_data(WalmartUpdate_object)
        self._update(new_price=new_price, new_stock=new_stock, new_sold_by_walmart=new_sold_by_walmart)
    
    def _update_from_api_data(self, JDSWalmartAPI_WalmartData_Object):
        [new_price, new_stock, new_sold_by_walmart, clearance] = self._convert_api_data_to_standard_data(JDSWalmartAPI_WalmartData_Object)
        self._update(new_price=new_price, new_stock=new_stock, new_sold_by_walmart=new_sold_by_walmart, known_is_clearance=clearance)
    
    def update_price_paid(self, new_price_paid):
        self._update(new_price_paid=new_price_paid)
    
    def _get_potential_savings_for_single_item(self):
        return (self._current_price_paid - self._current_known_price)
    
    def stocked_by_walmart(self):
        return (self._current_known_stock and self._current_known_sold_by_walmart)
    
    def get_refund_amount(self):
        if not self.stocked_by_walmart():
            return 0
        if self._known_is_clearance:
            return 0
        savings_per_qty = self._get_potential_savings_for_single_item()
        if savings_per_qty < 0:
            return 0
        return (self.quantity * savings_per_qty)
    
    def _pull_data_from_api(self):
        [JDSWalmartAPI_WalmartData_Object] = JDSWalmartAPI.walmart_id_to_data([self.walmartid], silent=True)
        return JDSWalmartAPI_WalmartData_Object
    
    def check_data_matches_api_and_update_if_not(self):
        JDSWalmartAPI_WalmartData_Object = self._pull_data_from_api()
        [api_price, api_stock, api_sold_by_walmart, clearance] = self._convert_api_data_to_standard_data(JDSWalmartAPI_WalmartData_Object)
        prices_match = self._current_known_price == api_price
        stocks_match = self._current_known_stock == api_stock
        sold_by_walmart_match = self._current_known_sold_by_walmart == api_sold_by_walmart
        clearance_match = self._known_is_clearance == clearance
        data_matches_api = (prices_match and stocks_match and sold_by_walmart_match and clearance_match)
        if not data_matches_api:
            self._update_from_api_data(JDSWalmartAPI_WalmartData_Object)
        return data_matches_api
    
    def get_refund_request_line(self):
        if self.get_refund_amount():
            return "WalmartID#{} has lowered in price by ${:.2f} to ${:.2f}, and was purchased in a quantity of {}.\n".format(self.walmartid, self._get_potential_savings_for_single_item(), self._current_known_price, self.quantity)
        else:
            return ""


class WalmartOrder:
    
    def __init__(self, OrderEmail_Object):
        self.order_number = OrderEmail_Object.get_order_number()
        self.arrives_by = OrderEmail_Object.get_arrives_by()
        self.billing_address = OrderEmail_Object.get_billing_address()
        self.initial_total_price_paid = OrderEmail_Object.get_total_price()
        self.shipped_from = OrderEmail_Object.get_ships_from()
        self.shipped_from_walmart = bool(self.shipped_from == "Walmart")
        self.email_time = OrderEmail_Object.getEpochTime()
        self.purchasing_email = OrderEmail_Object.getRecipient()
        self.has_been_partially_refunded_before = False
        
        products_dict = OrderEmail_Object.get_products_dict()
        for walmartid in products_dict:
            products_dict[walmartid]["shipped_from_walmart"] = self.shipped_from_walmart
        self.items = [WalmartOrderItem(products_dict[walmartid]) for walmartid in products_dict]
    
    def __repr__(self):
        order_string = "Order#{}\n".format(self.order_number)
        item_strings = "\n".join(["    " + repr(item) for item in self.items])
        return order_string + item_strings
    
    def contains_walmartid(self, walmartid):
        for item in self.items:
            if item.walmartid == walmartid:
                return True
        return False
    
    def has_arrived(self):
        assert type(self.arrives_by) is int, "WalmartOrder.arrives_by must be an epoch time integer."
        return (get_epoch_time()>=self.arrives_by)
    
    def is_older_than_90_days(self):
        return (days_ago(90)>=self.email_time)
    
    def update_from_SentRefundRequest_data(self, SentRefundRequest_Object):
        self.has_been_partially_refunded_before = True
        for item in self.items:
            maybe_new_price = SentRefundRequest_Object.new_prices.pop(item.walmartid, None)
            if maybe_new_price is not None:
                item.update_price_paid(maybe_new_price)
    
    def get_potential_refund_savings(self):
        Savings = 0.0
        for item in self.items:
            Savings += item.get_refund_amount()
        return Savings
        
    def should_send_refund_request(self):
        if not self.has_arrived():
            return False
        if not self.shipped_from_walmart:
            return False
        if self.is_older_than_90_days():
            return False
        return (self.get_potential_refund_savings() >= DOLLAR_THRESHOLD_FOR_REFUND_REQUEST)
    
    def _compose_refund_request_subject(self):
        base_string = "Partial Refund Request for Order#{}"
        return base_string.format(self.order_number)
    
    def _compose_refund_request_body(self):
        opening = "Hello,\n\nI am writing in reference to order # {}.".format(self.order_number)
        item_details = "".join([item.get_refund_request_line() for item in self.items])
        if self.has_been_partially_refunded_before:
            since_when = "last partial refund request"
        else:
            since_when = "purchase"
        total_difference = "In total, items in the order have lowered in price by ${:.2f} since my {}.".format(self.get_potential_refund_savings(), since_when)
        purchaser = "For reference, the purchasing email address registered on my walmart.com account is {}".format(self.purchasing_email)
        closing = "Can you please issue me a credit to my credit card to match the new price?\n\nKind regards,"
        body_text = "\n\n".join([opening, item_details, total_difference, purchaser, closing])
        return body_text
    
    def _check_no_refund_request_sent_since(self, epochtime):
        return not bool(get_refund_request_emails_from(epochtime))
    
    def _check_item_info_is_current(self):
        for item in self.items:
            if not item.check_data_matches_api_and_update_if_not():
                return False
        return True
    
    def check_refund_validity(self, last_checked_emails_time):
        return self._check_no_refund_request_sent_since(last_checked_emails_time) and self._check_item_info_is_current()
    
    def send_refund_request_if_valid(self, last_checked_emails_time, GmailConnection_Object):
        if self.should_send_refund_request():
            subject = self._compose_refund_request_subject()
            body = self._compose_refund_request_body()
            if self.check_refund_validity(last_checked_emails_time):
                GmailConnection_Object.send_email(subject, body, EMAIL_TO_SEND_TO)
                print("Refund Request Sent for Order#{}. (${:.2f} Saved)".format(self.order_number, self.get_potential_refund_savings()))
                time.sleep(60)
                return True
        return False



class WalmartUpdateChange:
    
    def __init__(self, change_data_dict):
        if change_data_dict is None:
            self.exists = False
            change_data_dict = dict()
        else:
            self.exists = True
        self.type = change_data_dict.pop("type", None)
        self.old = change_data_dict.pop("old", None)
        self.new = change_data_dict.pop("new", None)
        self.percent_change = change_data_dict.pop("percent_change", None)
    
    def __repr__(self):
        return "{}: {} -> {} ({})".format(self.type, self.old, self.new, self.percent_change)


class WalmartUpdate:
    
    def __init__(self, UpdateEmail_Object):
        self.walmartid = UpdateEmail_Object.get_item_id()
        self.availability = bool(strtobool(UpdateEmail_Object.get_availability()))
        self.current_price = UpdateEmail_Object.get_sales_price()
        self.time_of_changes = UpdateEmail_Object.get_time_changes_recorded()
        self.email_time = UpdateEmail_Object.getEpochTime()

        change_dict = UpdateEmail_Object.get_changes()
        self.stock_change = WalmartUpdateChange(change_dict.pop("availableOnline", None))
        self.price_change = WalmartUpdateChange(change_dict.pop("salePrice", None))
        self.marketplace_change = WalmartUpdateChange(change_dict.pop("marketplace", None))

        self.sold_by_walmart = None
        if self.marketplace_change.new in ["", "false"]:
            self.sold_by_walmart = True
        elif self.marketplace_change.new in ["true"]:
            self.sold_by_walmart = False
    
    def __repr__(self):
        changes = ""
        if self.stock_change.exists:
            changes += "\n\tStock       {}".format(repr(self.stock_change))
        if self.price_change.exists:
            changes += "\n\tPrice       {}".format(repr(self.price_change))
        if self.marketplace_change.exists:
            changes += "\n\tMarketplace {}".format(repr(self.marketplace_change))
        return "{} - avaliable:{}, price:{}, time:{}{}\n".format(self.walmartid, self.availability, self.current_price, self.time_of_changes, changes)
    
    def get_price(self):
        return self.current_price
    
    def get_stock(self):
        return self.availability
    
    def get_sold_by_walmart(self):
        return self.sold_by_walmart



class SentRefundRequest:
    
    def __init__(self, RefundRequestEmail_Object):
        self.order_number = RefundRequestEmail_Object.get_order_number()
        self.new_prices = RefundRequestEmail_Object.get_new_prices()



def get_epoch_time():
    return int(time.time())

def get_emails_from(after_epoch_time, EmailClass, GmailConnectionObject, before_epoch_time=None, progressbar_label="Pulling Emails: "):
    if before_epoch_time is None:
        before_epoch_time = int(time.time())
    query = "{} after:{} before:{}".format(EmailClass.SearchString, after_epoch_time, before_epoch_time)
    Email_Objects = GmailConnectionObject.get_jdsmessages_matching_query(query, EmailClass, progressbar_label=progressbar_label, none_found_text=None)
    Email_Objects = list(reversed(Email_Objects))
    for email in Email_Objects:
        if email.getAPullFailed():
            print("Error with pull from Email: {}".format(email.getSubject()))
    Suceeded_Email_Objects = [email for email in Email_Objects if not email.getAPullFailed()]
    return Suceeded_Email_Objects

def get_walmart_orders_from(after_epoch_time, before_epoch_time=None):
    return [WalmartOrder(item) for item in get_emails_from(after_epoch_time, OrderEmail, JDSEmails.GmailConnection("REDACTED", "read_emails"), before_epoch_time, progressbar_label="Pulling New Orders: ")]

def get_update_emails_from(after_epoch_time, before_epoch_time=None):
    return [WalmartUpdate(item) for item in get_emails_from(after_epoch_time, UpdateEmail, JDSEmails.GmailConnection("REDACTED", "read_emails"), before_epoch_time, progressbar_label="Pulling New Updates: ")]

def get_refund_request_emails_from(after_epoch_time, before_epoch_time=None):
    GMConn = JDSEmails.GmailConnection("notifications", "read_emails")
    def get_sent_refund_requests_of_type(email_class, progressbar_label):
        return [SentRefundRequest(item) for item in get_emails_from(after_epoch_time, email_class, GMConn, before_epoch_time, progressbar_label=progressbar_label)]
    sent_refund_requests = get_sent_refund_requests_of_type(RefundRequestEmail, "Pulling Sent Refund Requests: ")
    if DebugMode:
        sent_debug_refund_requests = get_sent_refund_requests_of_type(DebugRefundRequestEmail, "Pulling Sent Debug Refund Requests: ")
        sent_refund_requests.extend(sent_debug_refund_requests)
    return sent_refund_requests

def save_data_to_file(last_checked_emails_time, list_of_walmart_order_objects, filepath=DATA_FILE_PATH):
    data_dict = dict()
    data_dict["DataFormatVersion"] = DATA_FORMAT_VERSION
    data_dict["LastCheckedEmailsTime"] = last_checked_emails_time
    data_dict["WalmartOrders"] = list_of_walmart_order_objects
    pickle.dump(data_dict, open(filepath, "wb"))

def get_data_from_file(filepath=DATA_FILE_PATH):
    data_dict = pickle.load(open(filepath, "rb"))
    return [data_dict["DataFormatVersion"], data_dict["LastCheckedEmailsTime"], data_dict["WalmartOrders"]]


def get_starting_data(data_file_path):
    if os.path.exists(data_file_path):
        [data_format_version, last_checked_emails_time, walmart_orders] = get_data_from_file(data_file_path)
        if not data_format_version == DATA_FORMAT_VERSION:
            print("\"{}\" uses an older & incompatible format.\nIt will be deleted and a new one will be created.".format(data_file_path))
            os.remove(data_file_path)
    if not os.path.exists(data_file_path):
        data_format_version = None
        walmart_orders = []
        if DebugMode and PULL_SMALL_SET:
            last_checked_emails_time = days_ago(DAYS_TO_CHECK_IN_DEBUG)
        else:
            last_checked_emails_time = days_ago(90)
    return [data_format_version, last_checked_emails_time, walmart_orders]


def should_check_with_api(last_checked_emails_time):
    global already_asked_about_api_pull
    if days_ago(DAYS_OLD_TO_JUSTIFY_API_CHECK) > last_checked_emails_time:
        already_asked_about_api_pull = True
        return True
    else:
        if not already_asked_about_api_pull:
            already_asked_about_api_pull = True
            print("Do you want to initially update using the API?".format(DAYS_OLD_TO_JUSTIFY_API_CHECK))
            return JDSBasic.prompt_yes_no()
        else:
            return False


def remove_old_orders(walmart_orders):
    return [walmart_order for walmart_order in walmart_orders if not walmart_order.is_older_than_90_days()]

def update_walmart_orders_using_api(walmart_orders):
    walmartids = set()
    for order in walmart_orders:
        for item in order.items:
            walmartids.add(item.walmartid)

    JDSWalmartAPI_WalmartData_Objects = JDSWalmartAPI.walmart_id_to_data(list(walmartids), message="Pulling data from Walmart... ")
    JDSWalmartAPI_WalmartData_Objects_dict = dict()
    for JDSWalmartAPI_WalmartData_Object in JDSWalmartAPI_WalmartData_Objects:
        JDSWalmartAPI_WalmartData_Objects_dict[JDSWalmartAPI_WalmartData_Object.get_walmart_id()] = JDSWalmartAPI_WalmartData_Object
    
    for order in walmart_orders:
        for item in order.items:
            if item.walmartid in JDSWalmartAPI_WalmartData_Objects_dict:
                item._update_from_api_data(JDSWalmartAPI_WalmartData_Objects_dict[item.walmartid])

def update_walmart_orders_using_UpdateEmails(walmart_orders, last_checked_emails_time, new_checked_emails_time):
    WalmartUpdate_Objects = get_update_emails_from(last_checked_emails_time, new_checked_emails_time)
    for walmart_update in WalmartUpdate_Objects:
        for order in walmart_orders:
            for item in order.items:
                if item.walmartid == walmart_update.walmartid:
                    item.update_from_UpdateEmail_data(walmart_update)

def update_walmart_orders_using_SentRefundRequests(walmart_orders, last_checked_emails_time, new_checked_emails_time):
    SentRefundRequest_Objects = get_refund_request_emails_from(last_checked_emails_time, new_checked_emails_time)
    for SentRefundRequest_Object in SentRefundRequest_Objects:
        for order in walmart_orders:
            if SentRefundRequest_Object.order_number == order.order_number:
                order.update_from_SentRefundRequest_data(SentRefundRequest_Object)

def update_walmart_orders(walmart_orders, last_checked_emails_time, new_checked_emails_time):
    check_with_api = should_check_with_api(last_checked_emails_time)
    walmart_orders = remove_old_orders(walmart_orders)
    walmart_orders.extend(get_walmart_orders_from(last_checked_emails_time, new_checked_emails_time))
    if check_with_api:
        update_walmart_orders_using_api(walmart_orders)
    else:
        update_walmart_orders_using_UpdateEmails(walmart_orders, last_checked_emails_time, new_checked_emails_time)
    update_walmart_orders_using_SentRefundRequests(walmart_orders, last_checked_emails_time, new_checked_emails_time)
    return walmart_orders


def check_if_time_to_send_request():
    minutes_between_requests = (60 * 24) / EMAILS_TO_SEND_PER_DAY
    emails_sent_too_recently = get_refund_request_emails_from(minutes_ago(minutes_between_requests))
    enough_time_has_passed = not bool(emails_sent_too_recently)
    return enough_time_has_passed


def export_potential_refunds(walmart_orders):
    csv_lines = [",".join([order.order_number,
                           time.strftime("%m/%d/%y", time.gmtime(order.email_time)),
                           time.strftime("%m/%d/%y", time.gmtime(order.arrives_by)),
                           order.get_potential_refund_savings()]) for order in walmart_orders if order.should_send_refund_request()]
    with open("PotentialRefunds.csv", "w") as file:
        file.write("\r\n".join(["Order#,OrderDate,ArrivalDate,Savings"] + csv_lines))


def potential_refund_exists(walmart_orders):
    for order in walmart_orders:
        if order.should_send_refund_request():
            return True
    return False

def send_newest_and_oldest(walmart_orders, last_checked_emails_time):
    gmail_connection_for_sending = JDSEmails.GmailConnection("notifications", "read_and_send_emails")
    number_to_send_on_each_side = 10
    number_sent_on_this_side = 0
    for order in walmart_orders:
        if number_sent_on_this_side < number_to_send_on_each_side:
            if order.send_refund_request_if_valid(last_checked_emails_time, gmail_connection_for_sending):
                number_sent_on_this_side = number_sent_on_this_side + 1
    number_sent_on_this_side = 0
    for order in reversed(walmart_orders):
        if number_sent_on_this_side < number_to_send_on_each_side:
            if order.send_refund_request_if_valid(last_checked_emails_time, gmail_connection_for_sending):
                number_sent_on_this_side = number_sent_on_this_side + 1

def send_highest_value_refund(walmart_orders, last_checked_emails_time):
    gmail_connection_for_sending = JDSEmails.GmailConnection("notifications", "read_and_send_emails")
    while potential_refund_exists(walmart_orders):
        highest_value_refund = None
        highest_refund_value = 0
        for order in walmart_orders:
            if order.should_send_refund_request():
                if order.get_potential_refund_savings() > highest_refund_value:
                    highest_value_refund = order
                    highest_refund_value = highest_value_refund.get_potential_refund_savings()
        if highest_value_refund.send_refund_request_if_valid(last_checked_emails_time, gmail_connection_for_sending):
            return True
    return False

def send_refund_request_if_possible(walmart_orders, last_checked_emails_time):
    if check_if_time_to_send_request():
        refund_was_found = send_highest_value_refund(walmart_orders, last_checked_emails_time)
        if not refund_was_found:
            time.sleep(SECONDS_TO_WAIT_BETWEEN_CHECKING_FOR_NEW_EMAILS_IF_NONE_SENT)
    else:
        time.sleep(SECONDS_TO_WAIT_BETWEEN_CHECKING_FOR_NEW_EMAILS_IF_NONE_SENT)



[data_format_version, last_checked_emails_time, walmart_orders] = get_starting_data(DATA_FILE_PATH)
last_saved_time = last_checked_emails_time


looping = not DebugMode or PULL_SMALL_SET or STILL_LOOP
if SKIP_TO_DEBUG_RUNS:
    looping = False
while looping:
    looping = not DebugMode or STILL_LOOP
    new_checked_emails_time = get_epoch_time()
    walmart_orders = update_walmart_orders(walmart_orders, last_checked_emails_time, new_checked_emails_time)
    last_checked_emails_time = new_checked_emails_time
    if minutes_ago(MINUTES_BETWEEN_SAVING_DATA) > last_saved_time:
        save_data_to_file(last_checked_emails_time, walmart_orders)
        last_saved_time = last_checked_emails_time
    if EXPORT_ONLY:
        looping = False
        export_potential_refunds(walmart_orders)
    else:
        send_refund_request_if_possible(walmart_orders, last_checked_emails_time)


if DebugMode:
    def get_list_of_walmartids(walmart_orders):
        walmartids = set()
        for order in walmart_orders:
            for item in order.items:
                walmartids.add(item.walmartid)
        return walmartids
    
    def list_potential_refunds(walmart_orders):
        total_found = 0
        for order in walmart_orders:
            if order.should_send_refund_request():
                total_found = total_found + 1
                print("Order#:{} OrderDate:{} ArrivalDate:{} Savings:${:.2f}".format(order.order_number,
                                                                                     time.strftime("%m/%d/%y", time.gmtime(order.email_time)),
                                                                                     time.strftime("%m/%d/%y", time.gmtime(order.arrives_by)),
                                                                                     order.get_potential_refund_savings()))
        print("{} found.".format(total_found))
    
    GMConn = JDSEmails.GmailConnection("notifications", "read_emails")
    sent_refund_requests = GMConn.get_jdsmessages_matching_query(RefundRequestEmail.SearchString, RefundRequestEmail)[:300]
    srr = sent_refund_requests
    refunded_order_numbers = [refund_request.get_order_number() for refund_request in sent_refund_requests]
    ron = refunded_order_numbers
    refunded_order_numbers_no_consecutive_dupes = [ron[i] for i in range(len(ron)) if ron[i]!=ron[i-1]]
    rncd = refunded_order_numbers_no_consecutive_dupes
    refunded_order_numbers_no_dupes = [rncd[i] for i in range(len(rncd)) if rncd[i] not in rncd[:i]+rncd[i+1:]]
    rnd = refunded_order_numbers_no_dupes
    
    print("Done Running (Debug Mode)")
