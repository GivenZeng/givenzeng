### url编解码
#### 编码
url数据获取之后，并将其编码，从而适用与URL字符串中，使其能被打印和被web服务器接受。
```
urllib.quote(urlStr)和urllib.quote_plus(urlStr)
```
#### 解码
```
urllib.unquote(url)和urllib.unquote_plus(url)
```
