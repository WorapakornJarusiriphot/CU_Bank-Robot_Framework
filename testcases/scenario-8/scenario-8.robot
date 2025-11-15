*** Settings ***
Documentation     CU Bank UI tests for Login, Deposit, Withdraw (insufficient funds) and Transfer.
...               รวมทั้ง Scenario 8 : Login ผ่าน ฝากเงินผ่าน ถอนเงินไม่ผ่าน (เงินไม่พอ) โอนเงินผ่าน
Library           SeleniumLibrary
Library           OperatingSystem

Suite Setup       Open Browser To CU Bank
Suite Teardown    Close Browser
Test Teardown     Capture Screenshot For Test


*** Variables ***
${BROWSER}                 chrome
${BASE_URL}                http://localhost:3000
${VALID_ACCOUNT_ID}        1234567890
${VALID_PASSWORD}          1234
${TARGET_ACCOUNT_ID}       1234567891
${DEPOSIT_AMOUNT}          100
${TRANSFER_AMOUNT}         50
${WITHDRAW_GT_BALANCE}     9999999999
${WITHDRAW_ZERO}           0
${WITHDRAW_NEGATIVE}       -1
${WITHDRAW_DECIMAL}        17.03
${WITHDRAW_ALPHANUM}       3WOJA7
${SCREENSHOT_DIR}          ${OUTPUT DIR}${/}screenshots
${CAPTURE_ON_PASS}         True
${POSITIVE_AMOUNT_ERROR_MSG}    The amount must be greater than 0. Please enter a positive number.
${INSUFFICIENT_BALANCE_MSG}        Your balance is not enough to complete the withdrawal.

*** Test Cases ***
# =========================
# Scenario 8 – Weak Robust Equivalence Class
# =========================

TC8-01 Withdraw More Than Balance
    [Documentation]    Scenario 8 / TC8-01:
    ...                Login ผ่าน แล้ว Deposit 100 valid แล้ว Withdraw 200 (มากกว่า Balance: เงินไม่พอ) แล้ว Transfer 50 valid
    Login As Valid User

    # Deposit: valid
    ${before}=          Get Displayed Balance
    Deposit Amount      ${DEPOSIT_AMOUNT}
    ${expected_after_deposit}=    Evaluate    ${before} + ${DEPOSIT_AMOUNT}
    Wait For Balance To Equal     ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-01-Deposit100valid.png

    # Withdraw: invalid class EQ19 (amount > balance)
    Withdraw Amount     ${WITHDRAW_GT_BALANCE}
    Wait Until Page Contains    ${INSUFFICIENT_BALANCE_MSG}    10s
    Wait Until Page Contains Element    css:label[cid="withdraw-error-mes"]    10s
    ${after_withdraw}=  Get Displayed Balance
    Should Be Equal As Integers         ${after_withdraw}    ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-01-Withdrawมากกว่าBalance.png

    # Transfer: valid
    Transfer Amount     ${TARGET_ACCOUNT_ID}    ${TRANSFER_AMOUNT}
    ${expected_after_transfer}=   Evaluate    ${expected_after_deposit} - ${TRANSFER_AMOUNT}
    Wait For Balance To Equal     ${expected_after_transfer}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-01-Transfer50valid.png

TC8-02 Withdraw Amount Zero
    [Documentation]    Scenario 8 / TC8-02:
    ...                Login ผ่าน แล้ว Deposit 100 valid แล้ว Withdraw 0 (จำนวนเงินเป็นศูนย์) แล้ว Transfer 50 valid
    Login As Valid User

    # Deposit: valid
    ${before}=          Get Displayed Balance
    Deposit Amount      ${DEPOSIT_AMOUNT}
    ${expected_after_deposit}=    Evaluate    ${before} + ${DEPOSIT_AMOUNT}
    Wait For Balance To Equal     ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-02-Deposit100valid.png

    # Withdraw: invalid class EQ18 (amount = 0)
    Withdraw Amount     ${WITHDRAW_ZERO}
    Wait Until Page Contains    ${POSITIVE_AMOUNT_ERROR_MSG}    10s
    Sleep               0.5s
    ${after_withdraw}=  Get Displayed Balance
    Should Be Equal As Integers         ${after_withdraw}    ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-02-Withdrawศูนย์.png

    # Transfer: valid
    Transfer Amount     ${TARGET_ACCOUNT_ID}    ${TRANSFER_AMOUNT}
    ${expected_after_transfer}=   Evaluate    ${expected_after_deposit} - ${TRANSFER_AMOUNT}
    Wait For Balance To Equal     ${expected_after_transfer}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-02-Transfer50valid.png

TC8-03 Withdraw Negative Amount
    [Documentation]    Scenario 8 / TC8-03:
    ...                Login ผ่าน แล้ว Deposit 100 valid แล้ว Withdraw -1 (จำนวนเงินติดลบ) แล้ว Transfer 50 valid
    Login As Valid User

    # Deposit: valid
    ${before}=          Get Displayed Balance
    Deposit Amount      ${DEPOSIT_AMOUNT}
    ${expected_after_deposit}=    Evaluate    ${before} + ${DEPOSIT_AMOUNT}
    Wait For Balance To Equal     ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-03-Deposit100valid.png

    # Withdraw: invalid class EQ18 (amount < 0)
    Withdraw Amount     ${WITHDRAW_NEGATIVE}
    Wait Until Page Contains    ${POSITIVE_AMOUNT_ERROR_MSG}    10s
    Sleep               0.5s
    ${after_withdraw}=  Get Displayed Balance
    Should Be Equal As Integers         ${after_withdraw}    ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-03-Withdrawติดลบ.png

    # Transfer: valid
    Transfer Amount     ${TARGET_ACCOUNT_ID}    ${TRANSFER_AMOUNT}
    ${expected_after_transfer}=   Evaluate    ${expected_after_deposit} - ${TRANSFER_AMOUNT}
    Wait For Balance To Equal     ${expected_after_transfer}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-03-Transfer50valid.png

TC8-04 Withdraw Decimal Amount
    [Documentation]    Scenario 8 / TC8-04:
    ...                Login ผ่าน แล้ว Deposit 100 valid แล้ว Withdraw 17.03 (จำนวนทศนิยม) แล้ว Transfer 50 valid
    Login As Valid User

    # Deposit: valid
    ${before}=          Get Displayed Balance
    Deposit Amount      ${DEPOSIT_AMOUNT}
    ${expected_after_deposit}=    Evaluate    ${before} + ${DEPOSIT_AMOUNT}
    Wait For Balance To Equal     ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-04-Deposit100valid.png

    # Withdraw: invalid class EQ20 (ไม่ใช่จำนวนเต็ม)
    Withdraw Amount     ${WITHDRAW_DECIMAL}
    Sleep               0.5s
    ${after_withdraw}=  Get Displayed Balance
    Should Be Equal As Integers         ${after_withdraw}    ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-04-Withdrawทศนิยม.png

    # Transfer: valid
    Transfer Amount     ${TARGET_ACCOUNT_ID}    ${TRANSFER_AMOUNT}
    ${expected_after_transfer}=   Evaluate    ${expected_after_deposit} - ${TRANSFER_AMOUNT}
    Wait For Balance To Equal     ${expected_after_transfer}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-04-Transfer50valid.png

TC8-05 Withdraw With Alphabetic Characters
    [Documentation]    Scenario 8 / TC8-05:
    ...                Login ผ่าน แล้ว Deposit 100 valid แล้ว Withdraw 3WOJA7 (มีตัวอักษร) แล้ว Transfer 50 valid
    Login As Valid User

    # Deposit: valid
    ${before}=          Get Displayed Balance
    Deposit Amount      ${DEPOSIT_AMOUNT}
    ${expected_after_deposit}=    Evaluate    ${before} + ${DEPOSIT_AMOUNT}
    Wait For Balance To Equal     ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-05-Deposit100valid.png

    # Withdraw: invalid class EQ21 (มีตัวอักษร/อักขระพิเศษ)
    Withdraw Amount     ${WITHDRAW_ALPHANUM}
    Sleep               0.5s
    ${after_withdraw}=  Get Displayed Balance
    Should Be Equal As Integers         ${after_withdraw}    ${expected_after_deposit}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-05-Withdrawมีตัวอักษร.png

    # Transfer: valid
    Transfer Amount     ${TARGET_ACCOUNT_ID}    ${TRANSFER_AMOUNT}
    ${expected_after_transfer}=   Evaluate    ${expected_after_deposit} - ${TRANSFER_AMOUNT}
    Wait For Balance To Equal     ${expected_after_transfer}
    Sleep               0.5s
    Capture Page Screenshot    screenshots/TC8-05-Transfer50valid.png


*** Keywords ***
Open Browser To CU Bank
    [Documentation]    เปิด Browser และเตรียมโฟลเดอร์เก็บ Screenshot
    Create Directory    ${SCREENSHOT_DIR}
    Open Browser        ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s

Go To Login Page
    Go To                           ${BASE_URL}/
    Wait Until Page Contains Element    id=accountId    10s

Login As Valid User
    [Documentation]    ใช้ accountId/password ที่ valid ในระบบ
    Go To Login Page
    Input Text         id=accountId    ${VALID_ACCOUNT_ID}
    Input Text         id=password     ${VALID_PASSWORD}
    Click Button       css:button[cid="lc"]
    Wait Until Page Contains           Account ID:    10s

Get Balance Once
    [Documentation]    อ่านค่า Balance จากหน้า UI
    Wait Until Page Contains Element   xpath=//h2[normalize-space(.)="Balance:"]/following-sibling::h1[1]    10s
    ${text}=           Get Text        xpath=//h2[normalize-space(.)="Balance:"]/following-sibling::h1[1]
    ${value}=          Convert To Integer    ${text}
    RETURN             ${value}

Get Displayed Balance
    [Documentation]    อ่าน Balance โดย retry กรณี DOM ถูก re-render กัน StaleElementReferenceException
    ${value}=          Wait Until Keyword Succeeds    3x    0.5s    Get Balance Once
    RETURN             ${value}

Balance Should Be
    [Arguments]        ${expected}
    ${current}=        Get Displayed Balance
    Should Be Equal As Integers    ${current}    ${expected}

Wait For Balance To Equal
    [Arguments]        ${expected}
    Wait Until Keyword Succeeds    5x    0.5s    Balance Should Be    ${expected}

Deposit Amount
    [Arguments]        ${amount}
    [Documentation]    ฝากเงินด้วยจำนวน ${amount}
    Wait Until Page Contains Element    css:input[cid="d1"]    10s
    Clear Element Text                  css:input[cid="d1"]
    Input Text                          css:input[cid="d1"]    ${amount}
    Click Button                        css:button[cid="dc"]

Withdraw Amount
    [Arguments]        ${amount}
    [Documentation]    พยายามถอนเงินด้วยจำนวน ${amount}
    Wait Until Page Contains Element    css:input[cid="w1"]    10s
    Clear Element Text                  css:input[cid="w1"]
    Input Text                          css:input[cid="w1"]    ${amount}
    Click Button                        css:button[cid="wc"]

Transfer Amount
    [Arguments]        ${target_account_id}    ${amount}
    [Documentation]    โอน ${amount} ไปยังบัญชีเป้าหมาย ${target_account_id}
    Wait Until Page Contains           Transfer    10s
    Clear Element Text                 id=accountId
    Input Text                         id=accountId    ${target_account_id}
    Wait Until Page Contains Element   css:input[cid="t2"]    10s
    Clear Element Text                 css:input[cid="t2"]
    Input Text                         css:input[cid="t2"]    ${amount}
    Click Button                       css:button[cid="tc"]

Capture Screenshot For Test
    [Documentation]    จับ Screenshot ทุกครั้งที่จบเทสต์
    ${status}=         Set Variable    ${TEST STATUS}
    ${name}=           Set Variable    ${TEST NAME}
    Execute JavaScript    window.scrollTo(0,0);
    Run Keyword If     '${status}' == 'PASS' and '${CAPTURE_ON_PASS}' == 'True'
    ...    Capture Page Screenshot    ${SCREENSHOT_DIR}${/}PASS_${name}-scroll.png
    Run Keyword If     '${status}' == 'FAIL'
    ...    Capture Page Screenshot    ${SCREENSHOT_DIR}${/}FAIL_${name}-scroll.png
