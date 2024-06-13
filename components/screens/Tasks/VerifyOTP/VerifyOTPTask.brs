sub init()
    m.top.functionName = "MakePostRequestToVerifyOTP"
end sub

function MakePostRequestToVerifyOTP()
    otp = GetInputCode()
    deviceId = GetDeviceId()
    preAuthSessionId = GetPreAuthSessionId()
    print "MakePostRequestToVerifyOTP() - - - - - - - - - > START"
    data = {
        "userInputCode": otp,
        "deviceId": deviceId,
        "preAuthSessionId": preAuthSessionId,
    }
    ' {
    '     "userInputCode": "390465",
    '         "deviceId": "M55ERZDVd/fj2oxVGIHkF0Mm7YpjqN2CoM+FVbJ9fG0=",
    '     "flowType": "USER_INPUT_CODE",
    '     "preAuthSessionId": "cFwE3IZq_1Gxl6m3XXXtgk5Jeo09edbbGEvepF4hXJY",
    '     "appVersion": "1.0"
    ' }
    body = FormatJSON(data)
    port = CreateObject("roMessagePort")
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(port)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.RetainBodyOnError(true)
    request.AddHeader("Content-Type", "application/json")
    request.SetRequest("POST") ' Change the request method to POST
    request.SetUrl("https://uat-api.hoichoi.dev/core/api/v1/auth/signinup/code/consume") ' Set the URL
    requestSent = request.AsyncPostFromString(body) ' Send the JSON body in the request
    if (requestSent)
        msg = wait(0, port)
        if (type(msg) = "roUrlEvent")
            statusCode = msg.GetResponseCode()

            headers = msg.GetResponseHeaders()
            etag = headers["Etag"]
            body = msg.GetString()
            json = ParseJSON(body)
            print json

            if statusCode = 200
                userId = json["userId"]
                accessToken = json["sAccessToken"]
                refreshToken = json["sRefreshToken"]
                m.top.userId = userId
                m.top.accessToken = accessToken
                m.top.refreshToken = refreshToken
                SetUserId(userId)
                SetAccessToken(accessToken)
                SetRefreshToken(refreshToken)
            end if

            if statusCode = 503
                'unhide when server not available
                '
            end if

        end if
    end if
    print "MakePostRequestToVerifyOTP() - - - - - - - - - > END"
end function

'for response
function GetAccessToken() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("ACCESS_TOKEN")
        return sec.Read("ACCESS_TOKEN")
    end if
    return invalid
end function

function SetAccessToken(accessToken as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("ACCESS_TOKEN", accessToken)
    sec.Flush()
end function

function GetRefreshToken() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("REFRESH_TOKEN")
        return sec.Read("REFRESH_TOKEN")
    end if
    return invalid
end function

function SetRefreshToken(refreshToken as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("REFRESH_TOKEN", refreshToken)
    sec.Flush()
end function

function GetUserId() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("USER_ID")
        return sec.Read("USER_ID")
    end if
    return invalid
end function

function SetUserId(userId as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("USER_ID", userId)
    sec.Flush()
end function

'for request
function GetDeviceId() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("DEVICE_ID")
        return sec.Read("DEVICE_ID")
    end if
    return invalid
end function

function GetPreAuthSessionId() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("PRE_AUTH_SESSION_ID")
        return sec.Read("PRE_AUTH_SESSION_ID")
    end if
    return invalid
end function

function GetInputCode() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("INPUT_CODE")
        return sec.Read("INPUT_CODE")
    end if
    return invalid
end function