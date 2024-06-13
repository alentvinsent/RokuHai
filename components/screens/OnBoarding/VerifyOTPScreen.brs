function init()
    setUpUI()
end function

sub setUpUI()
    m.top.backgroundColor = "#111010"
    m.top.backgroundURI = ""
    padding = 40
    screenWidth = 1280
    screenHeight = 720

    qr_title = m.top.findNode("otp_title")
    qr_title.font.size = 22
    
    ph_title = m.top.findNode("otp_description")
    ph_title.font.size = 11

    resend_otp = m.top.findNode("resend_otp")
    resend_otp.font.size = 11

    change_mb_no = m.top.findNode("change_mb_no")
    change_mb_no.font.size = 11

    validate_otp = m.top.findNode("validate_otp")
    validate_otp.font.size = 15
    

    
end sub
