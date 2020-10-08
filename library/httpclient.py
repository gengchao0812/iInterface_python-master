import requests
import urllib3


class HttpClient:
    """Generic Http Client class"""

    def __init__(self, disable_ssl_verify=False, timeout=60):
        """Initialize method"""
        #初始化
        self.client = requests.session()
        self.disable_ssl_verify = disable_ssl_verify
        self.timeout = timeout
        if self.disable_ssl_verify:
            urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    def Get(self, url, headers=None, data=None, json=None, params=None, *args, **kwargs):
        """Http get method"""

        if headers is None:
            headers = {}
        #get动作
        if self.disable_ssl_verify:
            response = self.client.get(url, headers=headers, data=data, json=json, params=params
                                       , verify=False, timeout=self.timeout, *args, **kwargs)
        else:
            response = self.client.get(url, headers=headers, data=data, json=json, params=params
                                       , timeout=self.timeout, *args, **kwargs)
        #打印
        response.encoding = 'utf-8'
        print(f'{response.json()}')
        #返回
        return response
