function init()
    print "init() - - - - - - - - - > START"

    timer = m.top.findNode("exampleTimer")
    timer.ObserveField("fire", "onTimerFire")
    timer.control = "start"
    ' Start the first API call
    setUpUI()
end function

' Function to handle timer fire event
sub onTimerFire()
    m.getActivationCodeTask = createObject("roSGNode", "GetActivationCodeTask")
    m.getActivationCodeTask.control = "RUN"
end sub


sub setUpUI()
    m.top.backgroundColor = "#0e0f0e"
    m.top.backgroundURI = ""
    setUpFirst()
    setupKeyboard()
end sub

sub setUpFirst()
    m.first_screen = m.top.findNode("QRPhoneNoLoginScreen")
    m.second_screen = m.top.findNode("VerifyOTPScreen")
    m.keyboard_second = m.second_screen.findNode("keyboard")
    m.keyboard_second.observeField("text", "onKeyboardTextChanged")

    m.col_1 = m.second_screen.findNode("col_1")
    m.col_2 = m.second_screen.findNode("col_2")
    m.col_3 = m.second_screen.findNode("col_3")
    m.col_4 = m.second_screen.findNode("col_4")
    m.col_5 = m.second_screen.findNode("col_5")
    m.col_6 = m.second_screen.findNode("col_6")
    m.col_7 = m.second_screen.findNode("col_7")

    m.validate_otp_rect = m.second_screen.findNode("validate_otp_rect")
    m.validate_otp_rect.color = "#2a2b2b"

    qr_title = m.first_screen.findNode("qr_title")
    qr_title.font.size = 18

    ph_title = m.first_screen.findNode("ph_title")
    ph_title.font.size = 16

    qr_description = m.first_screen.findNode("qr_description")
    qr_description.font.size = 10

    ph_description = m.first_screen.findNode("ph_description")
    ph_description.font.size = 10

    link = m.first_screen.findNode("link")
    link.font.size = 10

    country_code = m.first_screen.findNode("country_code")
    country_code.font.size = 11

    m.get_otp_rect = m.first_screen.findNode("get_otp_rect")
    m.get_otp = m.first_screen.findNode("get_otp_lbl")
    m.get_otp.font.size = 15

    m.keyboard = m.first_screen.findNode("keyboard")
    m.qr_code_view = m.first_screen.findNode("qr_code_view")
    m.no_input = m.first_screen.findNode("no_input")
    m.no_input.setFocus(true)
end sub

sub setupKeyboard()
    m.keyboard.observeField("text", "onTextEntered")
end sub

sub onTextEntered()
    ?"Text entered: "m.keyboard.text
    m.no_input.text = m.keyboard.text
end sub

function onKeyEvent(key, press) as boolean
    ? "[home_scene] onKeyEvent", key, press
    ? "key  ---- ";key
    ? "press --- --";press


    if m.first_screen.visible = true
        if key = "OK" and press and m.get_otp_rect.hasFocus()
            getOTP("https://uat-api.hoichoi.dev/core/api/v1/auth/signinup/code", m.keyboard.text)
            return true
        end if

        if key = "OK" and press and m.no_input.hasFocus()
            m.qr_code_view.visible = false
            m.keyboard.visible = true
            m.no_input.setFocus(false)
            m.keyboard.setFocus(true)
            return true
        end if

        if key = "down" and press and m.no_input.hasFocus()
            m.get_otp_rect.color = "0xFF0000"'red
            m.no_input.setFocus(false)
            m.get_otp_rect.setFocus(true)
            return true
        end if

        if key = "up" and press and m.get_otp_rect.hasFocus()
            m.get_otp_rect.color = "#1e1e1e"'grey
            m.get_otp_rect.setFocus(false)
            m.no_input.setFocus(true)
            return true
        end if

        if key = "back" and press and m.keyboard.visible
            m.keyboard.visible = false
            m.qr_code_view.visible = true
            m.no_input.setFocus(true)
            return true
        end if

        if key = "right" and press and m.keyboard.visible
            m.keyboard.visible = false
            m.qr_code_view.visible = true
            m.get_otp_rect.color = "0xFF0000"'red
            m.get_otp_rect.setFocus(true)
        end if
    end if

    if m.second_screen.visible = true
        m.keyboard_second.setFocus(true)

        if key = "back" and press
            m.keyboard_second.visible = true
            m.keyboard_second.setFocus(true)
            return true
        end if

        if key = "OK" and press and m.validate_otp_rect.hasFocus()
            m.keyboard_second.setFocus(false)
        end if

    end if
    return false
end function


function SetPhNo(ph_no as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("ph_no", ph_no)
    sec.Flush()
end function

sub getOTP(url, ph_no)
    ? url
    ? ph_no
    SetPhNo(ph_no)
    
    m.get_otp_task = createObject("roSGNode", "GetOTPTask")
    m.get_otp_task.observeField("response", "onResponse")
    m.get_otp_task.observeField("ph_no", "OnPhNoResponse")
    m.get_otp_task.observeField("get_otp_status", "OnGetOTPStatus")
    m.get_otp_task.url = url
    m.get_otp_task.ph_no = ph_no


    ' 'tasks have a control field with specific values
    m.get_otp_task.control = "RUN"
end sub

sub validateOTP(deviceId, preAuthSessionId, userInputCode)
    m.verifty_otp_task = createObject("roSGNode", "VerifyOTPTask")
    ' m.verifty_otp_task.deviceId = deviceId
    ' m.verifty_otp_task.preAuthSessionId = preAuthSessionId
    ' m.verifty_otp_task.userInputCode = userInputCode

    ' ? m.verifty_otp_task.deviceId
    ' ? m.verifty_otp_task.preAuthSessionId
    ' ? m.verifty_otp_task.userInputCode
    ' ? m.verifty_otp_task.control

    m.verifty_otp_task.control = "RUN"
end sub

sub OnPhNoResponse(obj)
    data = obj.getData()
    m.keyboard.text = data
end sub

sub OnGetOTPStatus(obj)
    status = obj.getData()
    if status = "OK"
        m.keyboard.text = "OKKKKKKKKKKK"
        m.first_screen.visible = false
        m.second_screen.visible = true
    end if
    if status = ""
        m.keyboard.text = "NOOOOOOOOOO!"
    end if
end sub


function onKeyboardTextChanged()
    keyboardText = m.keyboard_second.text
    print "Keyboard Text: " + keyboardText

    if Len(keyboardText) = 6
        m.validate_otp_rect.setFocus(true)
        SetInputCode(m.keyboard_second.text)
        validateOTP(m.get_otp_task.deviceId, m.get_otp_task.preAuthSessionId,m.keyboard_second.text)
    end if

    if Len(keyboardText) >= 6
        m.keyboard_second.visible = false 
        m.validate_otp_rect.color = "0xFF0000"
    else
        m.keyboard_second.visible = true
        m.validate_otp_rect.color = "#2a2b2b"
    end if
    updateOtpColumn(keyboardText)
end function

sub updateOtpColumn(keyboardText)
    if Len(keyboardText) = 1
        m.col_1.text = Mid(keyboardText, 1, 1)
    else if Len(keyboardText) = 2
        m.col_2.text = Mid(keyboardText, 2, 1)
    else if Len(keyboardText) = 3
        m.col_3.text = Mid(keyboardText, 3, 1)
    else if Len(keyboardText) = 4
        m.col_4.text = Mid(keyboardText, 4, 1)
    else if Len(keyboardText) = 5
        m.col_5.text = Mid(keyboardText, 5, 1)
    else if Len(keyboardText) = 6
        m.col_6.text = Mid(keyboardText, 6, 1)
    end if
end sub


function SetInputCode(inputCode as string) as void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("INPUT_CODE", inputCode)
    sec.Flush()
end function

