sub init()
    m.top.functionName = "MakePostRequestToGetOTP"
end sub

' Function to make the API call
function MakePostRequestToGetActivationCode()
    print "MakePostRequestToGetActivationCode() - - - - - - - - - > START"
    data = {
        "deviceId":"134"
    }
    body = FormatJSON(data)
    port = CreateObject("roMessagePort")
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(port)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.RetainBodyOnError(true)
    request.AddHeader("Content-Type", "application/json")
    request.SetRequest("POST") ' Change the request method to POST
    request.SetUrl("https://uat-api.hoichoi.dev/core/api/v1/user-device/generate-activation-code") ' Set the URL
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

            ? "before code 🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳0🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳🥳"
            if statusCode = 200
                

            end if

            if statusCode = 503
                'unhide when server not available
                '
            end if

        end if
    end if
    print "MakePostRequestToGetActivationCode() - - - - - - - - - > END"
end function