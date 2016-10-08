# The Grinder 3.11
# HTTP script recorded by TCPProxy at Mar 13, 2013 10:54:27 AM

from net.grinder.script import Test
from net.grinder.script.Grinder import grinder
from net.grinder.plugin.http import HTTPPluginControl, HTTPRequest
from HTTPClient import NVPair
connectionDefaults = HTTPPluginControl.getConnectionDefaults()
httpUtilities = HTTPPluginControl.getHTTPUtilities()

# To use a proxy server, uncomment the next line and set the host and port.
# connectionDefaults.setProxyServer("localhost", 8001)

def createRequest(test, url, headers=None):
    """Create an instrumented HTTPRequest."""
    request = HTTPRequest(url=url)
    if headers: request.headers=headers
    test.record(request, HTTPRequest.getHttpMethodFilter())
    return request

# These definitions at the top level of the file are evaluated once,
# when the worker process is started.

connectionDefaults.defaultHeaders = \
  [ NVPair('Accept-Encoding', 'gzip, deflate'),
    NVPair('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Firefox/10.0.12'),
    NVPair('Accept-Language', 'en-us,en;q=0.5'), ]

headers0= \
  [ NVPair('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'), ]

url0 = 'http://host01.example.com:7011'

# START
request101 = createRequest(Test(101, 'GET contacts'), url0, headers0)

request102 = createRequest(Test(102, 'GET /'), url0, headers0)

request103 = createRequest(Test(103, 'GET styles.css'), url0)

# BROWSE
request201 = createRequest(Test(201, 'GET dispatch'), url0)

# EDIT
request301 = createRequest(Test(301, 'GET dispatch'), url0)

# UPDATE
request401 = createRequest(Test(401, 'GET dispatch'), url0)


class TestRunner:
  """A TestRunner instance is created for each worker thread."""

  # A method for each recorded page.
  def page1(self):
    """GET contacts (requests 101-103)."""
    
    # Expecting 302 'Moved Temporarily'
    result = request101.GET('/contacts')

    request102.GET('/contacts/')
    self.token_operation = \
      httpUtilities.valueFromBodyURI('operation') # 'browse'

    grinder.sleep(19)
    request103.GET('/contacts/css/styles.css', None,
      ( NVPair('Accept', 'text/css,*/*;q=0.1'),
        NVPair('Referer', 'http://host01.example.com:7011/contacts/'), ))

    return result

  def page2(self):
    """GET dispatch (request 201)."""
    result = request201.GET('/contacts/dispatch' +
      '?operation=' +
      self.token_operation, None,
      ( NVPair('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'),
        NVPair('Referer', 'http://host01.example.com:7011/contacts/'), ))

    return result

  def page3(self):
    """GET dispatch (request 301)."""
    self.token_operation = \
      'edit'
    self.token_id = \
      '1'
    result = request301.GET('/contacts/dispatch' +
      '?operation=' +
      self.token_operation +
      '&id=' +
      self.token_id, None,
      ( NVPair('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'),
        NVPair('Referer', 'http://host01.example.com:7011/contacts/dispatch?operation=browse'), ))

    return result

  def page4(self):
    """GET dispatch (request 401)."""
    self.token_firstname = \
      'Homer'
    self.token_lastname = \
      'Simpson'
    self.token_street = \
      '742+Evergreen+Terrace'
    self.token_city = \
      'Springfield'
    self.token_state = \
      'IL'
    self.token_zipcode = \
      '62701'
    self.token_homephone = \
      '555-123-0000'
    self.token_workphone = \
      '555-326-4323'
    self.token_mobilephone = \
      '555-263-6334'
    self.token_operation = \
      'Update'
    result = request401.GET('/contacts/dispatch' +
      '?firstname=' +
      self.token_firstname +
      '&lastname=' +
      self.token_lastname +
      '&street=' +
      self.token_street +
      '&city=' +
      self.token_city +
      '&state=' +
      self.token_state +
      '&zipcode=' +
      self.token_zipcode +
      '&homephone=' +
      self.token_homephone +
      '&workphone=' +
      self.token_workphone +
      '&mobilephone=' +
      self.token_mobilephone +
      '&operation=' +
      self.token_operation, None,
      ( NVPair('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'),
        NVPair('Referer', 'http://host01.example.com:7011/contacts/dispatch?operation=edit&id=1'), ))

    return result

  def __call__(self):
    """Called for every run performed by the worker thread."""
    self.page1()      # GET contacts (requests 101-103)

    grinder.sleep(9312)
    self.page2()      # GET dispatch (request 201)

    grinder.sleep(11834)
    self.page3()      # GET dispatch (request 301)

    grinder.sleep(14240)
    self.page4()      # GET dispatch (request 401)


# Instrument page methods.
Test(100, 'Page 1').record(TestRunner.page1)
Test(200, 'Page 2').record(TestRunner.page2)
Test(300, 'Page 3').record(TestRunner.page3)
Test(400, 'Page 4').record(TestRunner.page4)
