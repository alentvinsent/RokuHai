sub init()
    m.top.functionName = "MakePostRequestToGetOTP"
end sub

function GetPhNo() as dynamic
    sec = CreateObject("roRegistrySection", "Authentication")
    if sec.Exists("ph_no")
        return sec.Read("ph_no")
    end if
    return invalid
end function

function MakePostRequestToGetOTP()
    print "MakePostRequestToGetOTP() - - - - - - - - - > START"
    phoneNumber = "+91"+GetPhNo()
    data = {
       ' "phoneNumber": "+919074555960"
        "phoneNumber":phoneNumber
    }
    body = FormatJSON(data)
    port = CreateObject("roMessagePort")
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(port)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.RetainBodyOnError(true)
    request.AddHeader("Content-Type", "application/json")
    request.SetRequest("POST") ' Change the request method to POST
    request.SetUrl("https://uat-api.hoichoi.dev/core/api/v1/auth/signinup/code") ' Set the URL
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
                'working code unhide when server available
                deviceId = json["deviceId"]
                flowType = json["flowType"]
                preAuthSessionId = json["preAuthSessionId"]
                status = json["status"]
                m.top.get_otp_status = status
                m.top.deviceId = deviceId
                m.top.preAuthSessionId = preAuthSessionId
                SetDeviceId(deviceId)
                SetPreAuthSessionId(preAuthSessionId)
            end if

            if statusCode = 503
                'unhide when server not available
                m.top.get_otp_status = "OK"
            end if

        end if
    end if

    print "MakePostRequestToGetOTP() - - - - - - - - - > END"
end function


function SetDeviceId(deviceId as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("DEVICE_ID", deviceId)
    sec.Flush()
end function

function SetPreAuthSessionId(preAuthSessionId as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("PRE_AUTH_SESSION_ID", preAuthSessionId)
    sec.Flush()
end function