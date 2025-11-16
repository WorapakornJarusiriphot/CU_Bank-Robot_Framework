*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser
Test Teardown    Reset Balance and Logout

*** Variables ***
${BROWSER}    Chrome
${URL}    http://localhost:3000/
${ACCOUNT_ID}    1234567890
${PASSWORD}    1234

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.15s

Login
    [Arguments]    ${account_id}    ${password}
    Input Text    id=accountId    ${account_id}
    Input Text    id=password    ${password}
    Click Button    xpath=//button[@cid="lc"]
    Wait Until Element Contains    xpath=//h2    Account ID:

Deposit Amount
    [Arguments]    ${amount}
    Input Text    xpath=//input[@cid="d1"]    ${amount}
    Click Button    xpath=//button[@cid="dc"]
    Sleep    1s

Withdraw Amount
    [Arguments]    ${amount}
    Input Text    xpath=//input[@cid="w1"]    ${amount}
    Click Button    xpath=//button[@cid="wc"]
    Sleep    1s

Transfer Amount
    [Arguments]    ${target_account}    ${amount}
    Input Text    xpath=//input[@cid="t1"]    ${target_account}
    Input Text    xpath=//input[@cid="t2"]    ${amount}
    Click Button    xpath=//button[@cid="tc"]

Reset Balance and Logout
    Withdraw Amount    50
    # <a href="/">LOG OUT</a>
    Click Link    xpath=//a[@href="/"]
    Sleep    1s

*** Test Cases ***
# Scenario 5 : Login ผ่าน ตามด้วย การฝากเงินที่ผ่าน ถอนเงินผ่าน และ โอนเงินไม่ผ่าน (ใส่เลขบัญชีที่จะรับเงินโอนผิด)
# Test Scenario 5: Login Deposit Withdraw pass Transfer fail
#     Login    ${ACCOUNT_ID}    ${PASSWORD}
#     Deposit Amount    1000
#     Withdraw Amount    500
#     Transfer Amount    0987654322    200
#     # Verify transfer failure message
#     Page Should Contain Element    xpath=//label[@cid="transfer-error-mes"]    We couldn't find the recipient's account. Please double-check the account ID.
    
TC5-01 Transfer fail when transferAmount < 0
    [Documentation]    TC5-01 | transfer fail (transferAmount < 0)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # เติมยอดและถอน (ตาม pre-condition)
    Deposit Amount    100
    Withdraw Amount    50

    # ทำการโอน โดยใส่จำนวนติดลบ
    Transfer Amount    1234567891    -1

    # รอผลข้อความ error (ปรับ selector ให้ตรงกับแอปของคุณ)
    Wait Until Page Contains    The amount must be greater than 0. Please enter a positive number.    timeout=5s

TC5-02 Transfer fail when transferAmount = 0
    [Documentation]    TC5-02 | transfer fail (transferAmount = 0)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # Deposit 100 and withdraw 50
    Deposit Amount    100
    Withdraw Amount    50

    # Attempt to transfer amount = 0
    Transfer Amount    1234567891    0

    # Verify error message
    Wait Until Page Contains    The amount must be greater than 0. Please enter a positive number.    timeout=5s
    Capture Page Screenshot

TC5-03 Transfer fail when transferAmount > balance
    [Documentation]    TC5-03 | transfer fail when transferAmount > balance
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # Deposit 100 → balance: 100
    Deposit Amount    100

    # Withdraw 50 → balance: 50
    Withdraw Amount    50

    # Transfer 100 (greater than balance)
    Transfer Amount    1234567891    100

    # Verify error message
    Wait Until Page Contains    Your balance is not enough to complete the transfer.    timeout=5s
    Capture Page Screenshot

TC5-04 Transfer fail when transferAmount is not an integer
    [Documentation]    TC5-04 | transfer fail (transferAmount is decimal number)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # Deposit 100 → balance: 100
    Deposit Amount    100

    # Withdraw 50 → balance: 50
    Withdraw Amount    50

    # Transfer 10.5 (invalid: not a whole number)
    Transfer Amount    1234567891    10.5

    # Verify error message
    Wait Until Page Contains    The balance amount must be a whole number with no decimals.    timeout=5s
    Capture Page Screenshot

TC5-05 Transfer fail when transferAmount is non-numeric
    [Documentation]    TC5-05 | transfer fail (transferAmount is non-numeric)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # Deposit 100 → balance: 100
    Deposit Amount    100

    # Withdraw 50 → balance: 50
    Withdraw Amount    50

    # Transfer 'abc' (invalid: non-numeric)
    Transfer Amount    1234567891    e1

    # Verify error message
    Wait Until Page Contains   Invalid balance amount. Please enter a valid number.    timeout=5s
    Capture Page Screenshot

TC5-06 Transfer fail when targetAccountNumber is shorter than 10 digits
    [Documentation]    TC5-06 | transfer fail (targetAccountNumber น้อยกว่า 10 หลัก)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # เติมยอดและถอน (ตาม pre-condition)
    Deposit Amount    100
    Withdraw Amount    50

    # ทำการโอน โดยใส่เลขบัญชีที่จะรับเงินโอนสั้นกว่า 10 หลัก
    Transfer Amount    123456789    50

    # รอผลข้อความ error
    Wait Until Page Contains    Your account ID must be exactly 10 digits long.    timeout=5s
    Capture Page Screenshot

TC5-07 Transfer fail when targetAccountNumber is longer than 10 digits
    [Documentation]    TC5-07 | transfer fail (targetAccountNumber มากกว่า 10 หลัก)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # เติมยอดและถอน (ตาม pre-condition)
    Deposit Amount    100
    Withdraw Amount    50

    # ทำการโอน โดยใส่เลขบัญชีที่จะรับเงินโอนยาวกว่า 10 หลัก
    Transfer Amount    12345678901    50

    # รอผลข้อความ error
    Wait Until Page Contains    Your account ID must be exactly 10 digits long.    timeout=5s
    Capture Page Screenshot

TC5-08 Transfer fail when targetAccountNumber is non-numeric
    [Documentation]    TC5-08 | transfer fail (targetAccountNumber เป็นตัวอักษร)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # เติมยอดและถอน (ตาม pre-condition)
    Deposit Amount    100
    Withdraw Amount    50

    # ทำการโอน โดยใส่เลขบัญชีที่จะรับเงินโอนเป็นตัวอักษร
    Transfer Amount    hello    50

    # รอผลข้อความ error
    Wait Until Page Contains    Your account ID should contain numbers only.    timeout=5s
    Capture Page Screenshot

TC5-09 Transfer fail when targetAccountNumber does not exist
    [Documentation]    TC5-09 | transfer fail (targetAccountNumber ไม่มีในระบบ)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # เติมยอดและถอน (ตาม pre-condition)
    Deposit Amount    100
    Withdraw Amount    50

    # ทำการโอน โดยใส่เลขบัญชีที่จะรับเงินโอนที่ไม่มีในระบบ
    Transfer Amount    1111111111    50

    # รอผลข้อความ error
    Wait Until Page Contains    We couldn't find the recipient's account. Please double-check the account ID.    timeout=5s
    Capture Page Screenshot

TC5-10 Transfer fail when targetAccountNumber is same as sender's account
    [Documentation]    TC5-10 | transfer fail (targetAccountNumber เหมือนกับบัญชีผู้ส่ง)
    # Pre-condition: assume account ${ACCOUNT_ID} มีอยู่แล้ว (ลงทะเบียน) และล็อกอินได้
    Login    ${ACCOUNT_ID}    ${PASSWORD}

    # เติมยอดและถอน (ตาม pre-condition)
    Deposit Amount    100
    Withdraw Amount    50

    # ทำการโอน โดยใส่เลขบัญชีที่จะรับเงินโอนที่เหมือนกับบัญชีผู้ส่ง
    Transfer Amount    ${ACCOUNT_ID}    50

    # รอผลข้อความ error
    Wait Until Page Contains    You cannot transfer to your own account.    timeout=5s
    Capture Page Screenshot




