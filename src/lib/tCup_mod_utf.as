//======================================================================
//    TsubuyakiSoup_mod_utf
//----------------------------------------------------------------------
//    HSPからTwitterを操作するモジュール。
//    OAuthに対応。API1.1へ対応。
//----------------------------------------------------------------------
//  Author : Takaya,kanahiron
//  CreateDate : 10/07/29
//  LastUpdate : 17/10/20
//======================================================================
/*  [HDL module infomation]

%dll
TsubuyakiSoup

%ver
0.1

%date
2010/11/14

%note
TsubuyakiSoup.asをインクルードすること。

%port
Win

%*/

#ifndef machine_base64
#include "machine_base64.as"
#endif

#module tCup

#uselib "advapi32.dll"
#cfunc _CryptAcquireContext "CryptAcquireContextW" wptr, wptr, wptr, wptr, wptr
#func _CryptCreateHash "CryptCreateHash" wptr, wptr, wptr, wptr, wptr
#func _CryptHashData "CryptHashData" wptr, wptr, wptr, wptr
#func _CryptSetHashParam "CryptSetHashParam" wptr, wptr, wptr, wptr
#func _CryptGetHashParam "CryptGetHashParam" wptr, wptr, wptr, wptr, wptr
#func _CryptImportKey "CryptImportKey" wptr, wptr, wptr, wptr, wptr, wptr
#func _CryptDestroyKey "CryptDestroyKey" wptr
#func _CryptDestroyHash "CryptDestroyHash" wptr
#func _CryptReleaseContext "CryptReleaseContext" wptr, wptr
#func _CryptDeriveKey "CryptDeriveKey" wptr, wptr, wptr, wptr, wptr
#func _CryptEncrypt "CryptEncrypt" wptr, wptr, wptr, wptr, wptr, wptr, wptr
#func _CryptDecrypt "CryptDecrypt" wptr, wptr, wptr, wptr, wptr, wptr
//---------------
//  wininet.dll
//---------------
#uselib "wininet.dll"
#func _InternetOpen "InternetOpenW" wptr, wptr, wptr, wptr, wptr
#func _InternetReadFile "InternetReadFile" wptr, wptr, wptr, wptr
#func _InternetWriteFile "InternetWriteFile" wptr, wptr, wptr, wptr
#func _InternetCloseHandle "InternetCloseHandle" wptr
#func _InternetConnect "InternetConnectW" wptr, wptr, wptr, wptr, wptr, wptr, wptr, wptr
#func _HttpOpenRequest "HttpOpenRequestW" wptr, wptr, wptr, wptr, wptr, wptr, wptr, nullptr
#func _HttpSendRequest "HttpSendRequestW" wptr, wptr, wptr, wptr, wptr
#func _HttpSendRequestEx "HttpSendRequestExW" wptr, wptr, wptr, wptr, wptr
#func _HttpEndRequest "HttpEndRequestW" wptr, wptr, wptr, wptr
#func _HttpQueryInfo "HttpQueryInfoW" wptr, wptr, wptr, wptr, wptr
#func _InternetQueryDataAvailable "InternetQueryDataAvailable" wptr, wptr, wptr, wptr
#func _InternetSetOption "InternetSetOptionW" wptr, wptr, wptr, wptr
//---------------
//  crtdll.dll
//---------------
#uselib "crtdll.dll"
#func _time "time" var

#uselib "kernel32.dll"
#func getlastError "GetLastError"
#func MultiByteToWideChar "MultiByteToWideChar" wptr,wptr,sptr,wptr,wptr,wptr

#define HP_HMAC_INFO                            0x0005
#define PLAINTEXTKEYBLOB                        0x8
#define CUR_BLOB_VERSION                        2
#define PROV_RSA_FULL                           1
#define CRYPT_IPSEC_HMAC_KEY                    0x00000100
#define HP_HASHVAL                              0x0002
#define ALG_CLASS_HASH                          (4 << 13)
#define ALG_TYPE_ANY                            (0)
#define ALG_SID_SHA1                            4
#define ALG_SID_HMAC                            9
#define ALG_CLASS_DATA_ENCRYPT                  (3 << 13) // 0x6000
#define ALG_TYPE_BLOCK                          (3 << 9)  // 0x0600
#define ALG_SID_RC2                             2         // 0x0002
#define CALG_SHA1                               (ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_SHA1)
#define CALG_HMAC                               (ALG_CLASS_HASH | ALG_TYPE_ANY | ALG_SID_HMAC)
#define CALG_RC2                                (ALG_CLASS_DATA_ENCRYPT|ALG_TYPE_BLOCK|ALG_SID_RC2)

#define CRYPT_NEWKEYSET			$00000008
#define CRYPT_VERIFYCONTEXT     $F0000000
#define CRYPT_DELETEKEYSET		$00000010
#define CRYPT_MACHINE_KEYSET	$00000020
//

#define INTERNET_OPEN_TYPE_PRECONFIG			0
#define INTERNET_OPEN_TYPE_DIRECT               1
#define INTERNET_OPEN_TYPE_PROXY				3
#define INTERNET_OPTION_CONNECT_TIMEOUT         2
#define INTERNET_OPTION_HTTP_DECODING           65
#define INTERNET_DEFAULT_HTTPS_PORT             443
#define INTERNET_SERVICE_HTTP                   3
#define INTERNET_FLAG_RELOAD                    0x80000000
#define INTERNET_FLAG_SECURE                    0x00800000
#define INTERNET_FLAG_NO_CACHE_WRITE            0x04000000
#define INTERNET_FLAG_DONT_CACHE                INTERNET_FLAG_NO_CACHE_WRITE
#define INTERNET_FLAG_IGNORE_CERT_DATE_INVALID  0x00002000
#define INTERNET_FLAG_IGNORE_CERT_CN_INVALID    0x00001000

#define HTTP_QUERY_MIME_VERSION 0
#define HTTP_QUERY_CONTENT_TYPE 1
#define HTTP_QUERY_CONTENT_TRANSFER_ENCODING 2
#define HTTP_QUERY_CONTENT_ID 3
#define HTTP_QUERY_CONTENT_DESCRIPTION 4
#define HTTP_QUERY_CONTENT_LENGTH 5
#define HTTP_QUERY_CONTENT_LANGUAGE 6
#define HTTP_QUERY_ALLOW 7
#define HTTP_QUERY_PUBLIC 8
#define HTTP_QUERY_DATE 9
#define HTTP_QUERY_EXPIRES 10
#define HTTP_QUERY_LAST_MODIFIED 11
#define HTTP_QUERY_MESSAGE_ID 12
#define HTTP_QUERY_URI 13
#define HTTP_QUERY_DERIVED_FROM 14
#define HTTP_QUERY_COST 15
#define HTTP_QUERY_LINK 16
#define HTTP_QUERY_PRAGMA 17
#define HTTP_QUERY_VERSION 18
#define HTTP_QUERY_STATUS_CODE 19
#define HTTP_QUERY_STATUS_TEXT 20
#define HTTP_QUERY_RAW_HEADERS 21
#define HTTP_QUERY_RAW_HEADERS_CRLF 22
#define HTTP_QUERY_CONNECTION 23
#define HTTP_QUERY_ACCEPT 24
#define HTTP_QUERY_ACCEPT_CHARSET 25
#define HTTP_QUERY_ACCEPT_ENCODING 26
#define HTTP_QUERY_ACCEPT_LANGUAGE 27
#define HTTP_QUERY_AUTHORIZATION 28
#define HTTP_QUERY_CONTENT_ENCODING 29
#define HTTP_QUERY_FORWARDED 30
#define HTTP_QUERY_FROM 31
#define HTTP_QUERY_IF_MODIFIED_SINCE 32
#define HTTP_QUERY_LOCATION 33
#define HTTP_QUERY_ORIG_URI 34
#define HTTP_QUERY_REFERER 35
#define HTTP_QUERY_RETRY_AFTER 36
#define HTTP_QUERY_SERVER 37
#define HTTP_QUERY_TITLE 38
#define HTTP_QUERY_USER_AGENT 39
#define HTTP_QUERY_WWW_AUTHENTICATE 40
#define HTTP_QUERY_PROXY_AUTHENTICATE 41
#define HTTP_QUERY_ACCEPT_RANGES 42
#define HTTP_QUERY_SET_COOKIE 43
#define HTTP_QUERY_COOKIE 44
#define HTTP_QUERY_REQUEST_METHOD 45
#define HTTP_QUERY_MAX 45
#define HTTP_QUERY_CUSTOM 65535
#define HTTP_QUERY_FLAG_REQUEST_HEADERS 0x80000000
#define HTTP_QUERY_FLAG_SYSTEMTIME 0x40000000
#define HTTP_QUERY_FLAG_NUMBER 0x20000000
#define HTTP_QUERY_FLAG_COALESCE 0x10000000
#define HTTP_QUERY_MODIFIER_FLAGS_MASK (HTTP_QUERY_FLAG_REQUEST_HEADERS|HTTP_QUERY_FLAG_SYSTEMTIME|HTTP_QUERY_FLAG_NUMBER|HTTP_QUERY_FLAG_COALESCE)
#define HTTP_QUERY_HEADER_MASK (~HTTP_QUERY_MODIFIER_FLAGS_MASK)


//------------------------------
//  定数
//------------------------------
//HTTPメソッド
#define global METHOD_GET    0
#define global METHOD_POST   1
#define global METHOD_DELETE 2
#define global METHOD_PUT    3
#define global FORMAT_JSON   0
#define global FORMAT_XML    1

#define BLOCK_SIZE 8192



//============================================================
/*  [HDL symbol infomation]

%index
tCupInit
TsubuyakiSoupの初期化

%prm
p1, p2, p3
p1 = 文字列      : ユーザエージェント
p2 = 文字列      : Consumer Key
p3 = 文字列      : Consumer Secret
p4 = 0～(30)     : タイムアウトの時間(秒)

%inst
TsubyakiSoupモジュールの初期化をします。Twitter操作命令の使用前に呼び出す必要があります。

p1にユーザエージェントを指定します。ユーザエージェントを指定していないとSearchAPIなどで厳しいAPI制限を受けることがあります。

p2にConsumer Keyを、p3にConsumer Secretを指定してください。Consumer KeyとConsumer Secretは、Twitterから取得する必要があります。詳しくは、リファレンスをご覧ください。

p4にはTwitterと通信する際のタイムアウトの時間を秒単位で指定してください。

%href
TS_End

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#deffunc _tCupInit str p1, str p2, str p3, int p4

	//各種変数の初期化
;	rateLimit(0) = -1		// 15分間にAPIを実行できる回数
;	rateLimit(1) = -1		// APIを実行できる残り回数
;	rateLimit(2) = -1		// リセットする時間
	accessToken = ""		// AccessToken
	accessSecret = ""		// AccessTokenSecret
	requestToken = ""		// RequestToken
	requestSecret = ""		// RequestTokenSecret
	consumerKey = p2		// ConsumerKey
	consumerSecret = p3		// ConsumerSecret
	screenName = ""
	userId = ""
	formatType = "json"
	responseHeader = ""
	responseBody = ""
	timeOutTime = p4*1000
	gzipFlag = 1 // true /-------------------
	sdim userAgent,strlen(p1)*3
	cnvstow userAgent, p1
	//インターネットオープン
	hInet = _InternetOpen( varptr(_userAgent), INTERNET_OPEN_TYPE_PRECONFIG, 0, 0, 0)
	if hInet = 0:return -1
	_InternetSetOption hInet, INTERNET_OPTION_CONNECT_TIMEOUT, varptr(timeOutTime), 4
	_InternetSetOption hInet, INTERNET_OPTION_HTTP_DECODING, varptr(gzipFlag), 4
return 0
#define global tCupInit(%1,%2,%3,%4=5) _tCupInit %1, %2, %3, %4
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
tCupWash
TsubuyakiSoupの終了処理

%inst
TsubyakiSoupモジュールの終了処理を行ないます。
プログラム終了時に自動的に呼び出されるので明示的に呼び出す必要はありません。

%href
TS_Init

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#deffunc tCupWash onexit
	//ハンドルの破棄
	if (hRequest) : _InternetCloseHandle hRequest
	if (hConnect) : _InternetCloseHandle hConnect
	if (hInet) : _InternetCloseHandle hInet
return
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
getHmacSha1
HMAC-SHA1で署名を生成

%prm
(p1, p2)
p1 = 文字列    : 署名化する文字列
p2 = 文字列    : 鍵とする文字列

%inst
SHA-1ハッシュ関数を使用したハッシュメッセージ認証コード（HMAC）を返します。

p1に署名化する文字列を指定します。

署名化するための鍵（キー）は、p2で文字列で指定します。

%href
sigEncode

%group
TsubuyakiSoup補助関数

%*/
//------------------------------------------------------------
#deffunc getHmacSha1 str _p1, str _p2, var ghc_dest

	ghc_p1 = _p1
	ghc_p2 = _p2

	hProv = 0
	hKey  = 0
	hHash = 0

	ghc_dataLength = 0
	sdim hmacInfo,14
	lpoke hmacInfo, 0, CALG_SHA1

	ghc_p2Length = strlen(ghc_p2)
	dim keyBlob, 3+(ghc_p2Length/4)+1

	poke keyBlob, 0, PLAINTEXTKEYBLOB
	poke keyBlob, 1, CUR_BLOB_VERSION
	wpoke keyBlob, 2, 0
	lpoke keyBlob, 4, CALG_RC2
	lpoke keyBlob, 8, ghc_p2Length
	memcpy keyBlob, ghc_p2, ghc_p2Length, 12, 0

	sdim ghc_dest, 20
	ghc_dest = "Error"

	//コンテキストの取得
	if ( _CryptAcquireContext(varptr(hProv), 0, 0, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) ) {
		//キーのインポート
		if ( _CryptImportKey(hProv, varptr(keyBlob), (12+ghc_p2Length), 0, CRYPT_IPSEC_HMAC_KEY, varptr(hKey)) ) {
			if ( _CryptCreateHash(hProv, CALG_HMAC, hKey, 0, varptr(hHash)) ) {
				if ( _CryptSetHashParam(hHash, HP_HMAC_INFO, varptr(hmacInfo), 0) ) {
					if ( _CryptHashData(hHash, varptr(ghc_p1), strlen(ghc_p1), 0) ) {
						if ( _CryptGetHashParam(hHash, HP_HASHVAL, 0, varptr(ghc_dataLength), 0) ) {
							ghc_dest = ""
							if ( _CryptGetHashParam(hHash, HP_HASHVAL, varptr(ghc_dest), varptr(ghc_dataLength), 0) ) {
							}
						}
					}
				}
				//ハッシュハンドルの破棄
				_CryptDestroyHash hHash
			}
			//キーハンドルの破棄
			_CryptDestroyKey hKey
		}
		//ハンドルの破棄
		_CryptReleaseContext hProv, 0
	}
return
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
sigEncode
OAuth/xAuth用シグネチャを生成

%prm
(p1, p2)
p1 = 文字列    : 署名化する文字列
p2 = 文字列    : 鍵とする文字列

%inst
OAuth/xAuth用の署名を返します。

p1に署名化する文字列を指定します。

署名化するための鍵（キー）は、p2で文字列で指定します。

Twitterのシグネチャ生成の仕様より、
文字コードUTF-8でURLエンコードした文字列（p1）を、同じくURLエンコードした文字列（p2）をキーとしてHAMAC-SHA1方式で生成した署名を、BASE64エンコードしたうえURLエンコードしています。

%href
HMAC_SHA1

%group
TsubuyakiSoup補助関数

%*/
//------------------------------------------------------------
#defcfunc sigEncode str se_p1, str se_p2
	SigTmp = se_p1
	SecretTmp = se_p2
	//URLエンコード
	SigEnc = form_encode(SigTmp, 0)
	SecretEnc = form_encode(SecretTmp, 0)
	getHmacSha1 SigEnc, SecretEnc, HmacSha1
	if (HmacSha1 == "Error"): return "Error"
	sdim base64HmacSha1,40
	Encode@machine_base64 HmacSha1,20,base64HmacSha1
return form_encode(str(base64HmacSha1), 0)
//============================================================


// str   p1 API
// array p2 argument
// int   p3 http method
#define global execRestApi(%1, %2, %3, %4=0) _execRestApi %1, %2, %3, %4
#deffunc _execRestApi str era_p1, array era_p2, int era_p3, int hProgress

	api = era_p1

	if (api != "media/upload.json") {
		arrayCopy era_p2, arguments
		argumentLength = length(arguments)
	} else {
		exist era_p2
		picLength = strsize
		sdim picBuf,picLength+1
		bload era_p2,picBuf
		sdim arguments
		argumentLength = 0
	}

	methodType = era_p3

	switch methodType
		case METHOD_GET
			method = "GET"
			swbreak
		case METHOD_POST
			method = "POST"
			swbreak
		case METHOD_PUT
			method = "PUT"
			swbreak
		case METHOD_DELETE
			method = "DELETE"
			swbreak
		default
			return 0
			swbreak
	swend

	logmes "===execRestApi==="
	logmes "api :"+api
	logmes "method :"+methodType
	logmes "arguments :"
	repeat length(arguments)
		logmes " "+cnt+" ["+arguments(cnt)+"]"
	loop

	sigArrayLength = 6+argumentLength
	sdim sigArray, 500, sigArrayLength

	hConnect = 0	// InternetConnectのハンドル
	hRequest = 0	// HttpOpenRequestのハンドル
	statCode = 0	// リクエストの結果コード
	intSize = 4		//int型のバイト数

	apiVersion = "1.1"	// TwitterAPIのバージョン

	RequestURL = "api.twitter.com"
	if (api = "media/upload.json") {
		RequestURL = "upload.twitter.com"
	}

	apiUrl = apiVersion +"/"+ api

	sdim transStr, 4096
	//OAuth1.0a用のシグネチャ作成
	transStr = method +" https://"+RequestURL+"/"+ apiVersion +"/"+ api +" "
	if (strmid(api,0,5) = "oauth") {
		apiUrl = api
		transStr = method +" https://api.twitter.com/"+ api +" "
	}

	tokenStr = accessToken
	sigKey = consumerSecret+" "+accessSecret
	//logmes "sigkey="+sigKey
	if (api = "oauth/access_token") {
		tokenStr = requestToken
		sigKey = consumerSecret+" "+requestSecret
	}

	sigNonce = getRandomString(8, 32)
	_time sigTime
	sigArray(0) = "oauth_consumer_key=" + consumerKey
	sigArray(1) = "oauth_nonce=" + sigNonce
	sigArray(2) = "oauth_signature_method=HMAC-SHA1"
	sigArray(3) = "oauth_timestamp=" + sigTime
	sigArray(4) = "oauth_token="+ tokenStr
	sigArray(5) = "oauth_version=1.0"

	if (api != "media/upload.json") {
		repeat argumentLength
			if (arguments(cnt) == ""):continue
			sigArray(6+cnt) = arguments(cnt)
		loop
	}

	sortstr sigArray, 0

	repeat sigArrayLength
		if sigArray(cnt) = "" : continue
		transStr += sigArray(cnt) +"&"
	loop
	transStr = strmid(transStr, 0, strlen(transStr)-1)
	signature = sigEncode(transStr, sigKey)
	//シグネチャ作成ここまで

	//リクエスト作成
	if (methodType = METHOD_POST) {

		sdim boundary,128
		boundary = "-------------"+getRandomString(24, 32)

		if (api = "media/upload.json") {

			sdim PostDataHead
			sdim PostDataFoot
			PostDataLength = 0

			PostDataHead = "--"+boundary+"\n"
			PostDataHead += "Content-Disposition: form-data; name=\"media\";\n"
			PostDataHead += "Content-Type: image/"
			switch getpath@getpathMod(era_p2, 18)
				case ".jpg"
				case ".jpeg"
					PostDataHead += "jpeg"
					swbreak
				case ".png"
					PostDataHead += "png"
					swbreak
				case ".gif"
					PostDataHead += "gif"
					swbreak
				case ".bmp"
					PostDataHead += "bmp"
					swbreak
			swend
			PostDataHead += "\n\n"
			PostDataFoot = "\n--"+boundary+"--\n"

			PostDataLength = strlen(PostDataHead) + strlen(PostDataFoot) + picLength

			sdim PostData,PostDataLength+1
			memcpy PostData, PostDataHead, strlen(PostDataHead), 0, 0
			memcpy PostData, picBuf, picLength, strlen(PostDataHead), 0
			memcpy PostData, PostDataFoot, strlen(PostDataFoot), strlen(PostDataHead)+picLength, 0

		} else {
			sdim PostData, 1024
			repeat argumentLength
				PostData += arguments(cnt)+"&"
			loop
			PostData = strmid(PostData, 0, strlen(PostData)-1) //後ろの&を除去
			PostDataLength = strlen(PostData)
			logmes "PostData: "+PostData
		}

		sdim AuthorizationStr
		AuthorizationStr = "Authorization: OAuth "
		repeat sigArrayLength
			if sigArray(cnt) = "" : continue
			AuthorizationStr += sigArray(cnt) +","
		loop
		AuthorizationStr += "oauth_signature=" +signature

		sdim RequestHeader,1024
		RequestHeader  = "Host: "+RequestURL+"\n"
		RequestHeader += "Accept-Charset: UTF-8\n"
		RequestHeader += "Accept-Encoding: gzip, deflate\n"
		if (api = "media/upload.json") {
			RequestHeader += "Content-Type: multipart/form-data; charset=UTF-8; boundary= "+boundary+"\n"
		} else {
			RequestHeader += "Content-Type: application/x-www-form-urlencoded; charset=UTF-8\n"
		}
		RequestHeader += "Content-Length: "+PostDataLength+"\n"
		RequestHeader += AuthorizationStr
	}

	if (methodType = METHOD_GET) {
		apiUrl += "?"
		repeat sigArrayLength
			if sigArray(cnt) = "" : continue
			apiUrl += sigArray(cnt) +"&"
		loop
		apiUrl += "oauth_signature=" +signature

		sdim RequestHeader,1024
		RequestHeader  = "Host: "+RequestURL+"\n"
		RequestHeader += "Accept-Charset: UTF-8\n"
		RequestHeader += "Accept-Encoding: gzip, deflate\n"
		RequestHeader += "Content-Type: application/x-www-form-urlencoded; charset=UTF-8"
		PostData = ""
		PostDataLength = 0
	}

	//ヘッダーをUTF-16LEに変換
	RequestHeaderWideLength = MultiByteToWideChar( 65001, 0, varptr(RequestHeader), strlen(RequestHeader), 0, 0) //UTF-16文字列の 文 字 数
	sdim RequestHeaderWide, (RequestHeaderWideLength*2)+2	//UTF-16文字列を入れるバッファを確保
	cnvstow RequestHeaderWide, RequestHeader				//バッファにUTF-8からUTF-16に変換して格納

	//HttpSendRequestEx用のINTERNET_BUFFERS構造体を作成
	dim INTERNET_BUFFERS, 10
	INTERNET_BUFFERS( 0) = 40
	INTERNET_BUFFERS( 2) = varptr(RequestHeaderWide)
	INTERNET_BUFFERS( 3) = RequestHeaderWideLength //リクエストヘッダの文字数
	INTERNET_BUFFERS( 7) = PostDataLength //RequestBodyだけのサイズ

	requestFlag = INTERNET_FLAG_NO_CACHE_WRITE
	requestFlag |= INTERNET_FLAG_SECURE

	//サーバへ接続
	hConnect = _InternetConnect(hInet, RequestURL, INTERNET_DEFAULT_HTTPS_PORT, 0, 0, INTERNET_SERVICE_HTTP, 0, 0)
	logmes "1 InternetConnect"
	if (hConnect) {
		//リクエストの初期化
		hRequest = _HttpOpenRequest(hConnect, method, apiURL, httpVer, 0, 0, requestFlag)
		logmes "2 HttpOpenRequest"
		if (hRequest) {
			//データ送信準備
			if _HttpSendRequestEx( hRequest, varptr(INTERNET_BUFFERS), 0, 0, 0) {
				logmes "3 HttpSendRequestEx"
				//リクエストボディの送信
				sentFailFlg = 0
				if (PostDataLength != 0){

					BytesWritten = 0
					sentSize = 0
					unSentSize = PostDataLength
					logmes "PostDataLength :"+PostDataLength
					logmes "unSentSize :"+unSentSize
					logmes "InternetWriteFile :"
					tSize = 0
					repeat
						//logmes "unSentSize "+unSentSize
						if (unSentSize = 0): break
						if (unSentSize < BLOCK_SIZE): tSize = unSentSize: else: tSize = BLOCK_SIZE
						//logmes " tSize :"+tSize

						_InternetWriteFile hRequest, varptr(PostData)+sentSize, tSize, varptr(BytesWritten)
						if (stat == 0): sentFailFlg = 1: break //送信失敗
						//logmes "BytesWritten "+BytesWritten
						sentSize += BytesWritten
						unSentSize -= BytesWritten
						//logmes " unSentSize :"+unSentSize
						//title@hsp strf("送信バイト数 %d/%dByte %.2f%%", sentSize, PostdataLength, (100.0*sentSize/PostDataLength))
						if hProgress: sendmsg hProgress, $402, int(100.0*sentSize/PostDataLength+0.9)+1: sendmsg hProgress, $402, int(100.0*sentSize/PostDataLength+0.9)
						await
					loop
					logmes "4 HttpSendRequestEx"
				}
				if (sentFailFlg == 0){
					if _HttpEndRequest( hRequest, 0, 0, 0){
						logmes "5 HttpEndRequest"

						ResponseBodySize = 0
						readTotalSize = 0
						readSize = 0

						_HttpQueryInfo hRequest, HTTP_QUERY_STATUS_CODE | HTTP_QUERY_FLAG_NUMBER, varptr(statCode), varptr(intSize), 0
						//logmes "StatCode "+statCode

						//入手可能なデータ量を取得
						_InternetQueryDataAvailable hRequest, varptr(ResponseBodySize), 0, 0
						logmes "ResponseBodySize :"+ResponseBodySize

						//バッファの初期化
						sdim readBuffer, BLOCK_SIZE+1
						sdim responseBody, ResponseBodySize+1
						repeat
							_InternetReadFile hRequest, varptr(readBuffer), BLOCK_SIZE, varptr(readSize)
							if (readSize = 0) : break
							if ((readTotalSize+readSize)>ResponseBodySize): memexpand responseBody, (readTotalSize+readSize+1): logmes "ResBody拡張 :"+(readTotalSize+readSize+1)
							memcpy responseBody, readBuffer, readSize, readTotalSize, 0
							readTotalSize += readSize
						loop
						logmes "6 InternetReadFile"
					}
				}
			}
			_InternetCloseHandle hRequest
		}
		_InternetCloseHandle hConnect
	}
///*
	#ifdef _debug
		nid = ginfo(3)
		screen 45,1200,500 //変数の内容表示
		mesbox RequestHeader,1200,75,0
		tempStr = b2s(PostData, PostDataLength)
		mesbox tempStr,1200,175,0
		mesbox responseHeader,1200,175,0
		mesbox responseBody,1200,75,0
		gsel nid
	#endif
//*/
	assert
	sdim requestHeader
	sdim postData
	sdim picBuf
	sdim transStr

return statcode

//===========================================================

#defcfunc getResponseHeader
return responseHeader

#defcfunc getResponseBody
return responseBody


//============================================================
/*  [HDL symbol infomation]

%index
SetAccessToken
AccessTokenとSecretを設定

%prm
p1, p2
p1 = 文字列      : Access Token
p2 = 文字列      : Access Secret

%inst
TsubuyakiSoupにAccess TokenとAccess Secretを設定します。

p1にAccess Tokenを、p2にAccess Secretを指定します。

このAccess TokenとAccess Secretは、GetAccessToken命令かGetxAuthToken命令で取得することができます。詳しくは、リファレンスをご覧ください。

%href
GetAccessToken
GetxAuthToken

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#deffunc setAccessToken str sat_p1, str sat_p2
	accessToken = sat_p1
	accessSecret = sat_p2
return
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
setRequestToken
RequestTokenとSecretを設定

%prm
p1, p2
p1 = 文字列      : Request Token
p2 = 文字列      : Request Secret

%inst
TsubuyakiSoupにRequest TokenとRequest Secretを設定します。

p1にRequest Tokenを、p2にRequest Secretを指定します。


%href
setAccessToken

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#deffunc setRequestToken str srt_p1, str srt_p2
	requestToken = srt_p1
	requestSecret = srt_p2
return
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
getRequestToken
RequestTokenとSecretを設定

%prm
()

%inst

%href
setAccessToken

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#defcfunc getRequestToken
return requestToken
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
getRequestSecret
RequestTokenとSecretを設定

%prm
()

%inst

%href
setAccessToken

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#defcfunc getRequestSecret
return requestSecret
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
setConsumerToken
AccessTokenとSecretを設定

%prm
p1, p2
p1 = 文字列      : Consumer Token
p2 = 文字列      : Consumer Secret

%inst
TsubuyakiSoupにConsumer TokenとConsumer Secretを設定します。

p1にConsumer Tokenを、p2にConsumer Secretを指定します。

%href
tCupInit

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#deffunc setConsumerToken str sct_p1, str sct_p2
	consumerToken = sct_p1
	consumerSecret = sct_p2
return
//============================================================

//============================================================
/*  [HDL symbol infomation]

%index
setUserInfo
ユーザ情報を設定

%prm
p1, p2
p1 = 文字列      : ユーザ名（スクリーン名）
p2 = 文字列      : ユーザID

%inst
TsubuyakiSoupにユーザ名（スクリーン名）とユーザIDを設定します。

p1にユーザ名（スクリーン名）を、p2にユーザIDを指定します。

TsubuyakiSoup2からユーザIDも文字列で処理しています。

%href
GetAccessToken
GetxAuthToken

%group
TwitterAPI操作命令

%*/
//------------------------------------------------------------
#deffunc setUserInfo str sui_p1, str sui_p2
	screenName = sui_p1
	userId = sui_p2
return
//============================================================

#global


#module

#uselib "kernel32.dll"
#cfunc _MultiByteToWideChar "MultiByteToWideChar" int, int, sptr, int, int, int

/*------------------------------------------------------------*/
//1バイト・2バイト判定
//
//	isByte(p1)
//		p1...判別文字コード
//		[0:1byte/1:2byte]
//
#defcfunc isByte int p1
return (p1>=129 and p1<=159) or (p1>=224 and p1<=252)
/*------------------------------------------------------------*/


#deffunc arrayCopy array ary1, array ary2
	dimtype ary2, vartype(ary1), length(ary1)
	foreach ary1
		ary2(cnt) = ary1(cnt)
	loop
return


/*------------------------------------------------------------*/
//半角・全角含めた文字数を取り出す
//
//	mb_strmid(p1, p2, p3)
//		p1...取り出すもとの文字列が格納されている変数名
//		p2...取り出し始めのインデックス
//		p3...取り出す文字数
//
#defcfunc mb_strmid var p1, int p2, int p3
	if vartype != 2 : return ""
	s_size = strlen(p1)
	trim_start = 0
	trim_num = 0
	repeat p2
		if (Is_Byte(peek(p1,trim_start))) : trim_start++
		trim_start++
	loop
	repeat p3
		if (Is_Byte(peek(p1,trim_start+trim_num))) : trim_num++
		trim_num++
	loop
return strmid(p1,trim_start,trim_num)



//p2 半角スペースの処理  0 : '&'  1 : '%20'
#defcfunc form_encode str p1, int p2
/*
09 az AZ - . _ ~
はそのまま出力
*/
fe_str = p1
fe_p1Long = strlen(p1)
sdim fe_val, fe_p1Long*3
repeat fe_p1Long
	fe_flag = 0
	fe_tmp = peek(fe_str, cnt)
	if (('0' <= fe_tmp)&('9' >= fe_tmp)) | (('A' <= fe_tmp)&('Z' >= fe_tmp)) | (('a' <= fe_tmp)&('z' >= fe_tmp)) | (fe_tmp = '-') | (fe_tmp = '.') | (fe_tmp = '_') | (fe_tmp = '~') :{
		poke fe_val, strlen(fe_val), fe_tmp
	} else {
		if fe_tmp = ' ' {
			if p2 = 0 : fe_val += "&"
			if p2 = 1 : fe_val += "%20"	//空白処理
		} else {
			fe_val += "%" + strf("%02X",fe_tmp)
		}
	}
loop
return fe_val

//ランダムな文字列を発生させる
//p1からp2文字まで
#defcfunc getRandomString int p1, int p2
;randomize
RS_Strlen = rnd(p2-p1+1) + p1
sdim RS_val, RS_Strlen
repeat RS_Strlen
	RS_rnd = rnd(3)
	if RS_rnd = 0 : RS_s = 48 + rnd(10)
	if RS_rnd = 1 : RS_s = 65 + rnd(26)
	if RS_rnd = 2 : RS_s = 97 + rnd(26)
	poke RS_val, cnt, RS_s
loop
return RS_val

#global

#module

#defcfunc strlen16 var p1

	repeat
		ccnt = cnt*2
		if peek(p1,ccnt) = 0{
			break
		}
	loop

return ccnt

#global
