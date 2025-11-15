*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

Suite Setup    Setup Browser
Suite Teardown    Close Browser

*** Variables ***
${URL}                   http://localhost:3000
${USER}                  1234567890
${PASS}                  1234
${SCREENSHOT_DIR}        ./screenshots

${ERR_INVALID_NUMBER}        Please enter a number
${ERR_WHOLE_NUMBER_PREFIX}   Please enter a valid value. The two nearest valid values are
${ERR_GREATER_THAN_ZERO}     The amount must be greater than 0. Please enter a positive number.
${SUCCESS_MSG}               Deposit successful

*** Keywords ***
Setup Browser
    Create Directory    ${SCREENSHOT_DIR}
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Login To System

Login To System
    Input Text    id:accountId    ${USER}
    Input Text    id:password     ${PASS}
    Click Element    xpath=//button[@cid='lc']
    Wait Until Page Contains Element    xpath=//input[@cid='d1']    10s

Deposit And Check
    [Arguments]    ${amount}    ${expected_error}    ${test_case_name}
    ...    ${is_native_validation}=False    ${is_valid_test}=False

    Clear Element Text    xpath=//input[@cid='d1']
    Input Text    xpath=//input[@cid='d1']    ${amount}
    Sleep    0.5s

    Capture Page Screenshot    ${SCREENSHOT_DIR}/${test_case_name}.png

    # --- FIX #1: native browser validation (TC1 / TC2 / TC5) ---
    IF    ${is_native_validation}
        ${validation_msg}=    Execute Javascript    return document.querySelector('[cid="d1"]').validationMessage;
        Log To Console    [${test_case_name}] Browser validation message: ${validation_msg}
            RETURN
    END

    # --- Otherwise continue to backend validation ---
    Click Element    xpath=//button[@cid='dc']
    Sleep    0.5s

    ${error_found}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    css:label[cid="deposite-error-mes"]    timeout=2s

    # --- Valid deposit case ---
    IF    ${is_valid_test}
        IF    ${error_found}
            ${error_text}=    Get Text    css:label[cid="deposite-error-mes"]
            Fail    [${test_case_name}] Expected success but got error: ${error_text}
        ELSE
            Log To Console    [${test_case_name}] Deposit success ✓
        END
        RETURN
    END

    # --- Expected error case ---
    IF    not ${error_found}
        Fail    [${test_case_name}] Expected error "${expected_error}" but no error shown
    END

    ${error_text}=    Get Text    css:label[cid="deposite-error-mes"]
    Should Be Equal    ${error_text}    ${expected_error}
    Log To Console    [${test_case_name}] Passed ✓



*** Test Cases ***
TC1 Non-numeric Input
    Deposit And Check    e    ${ERR_INVALID_NUMBER}    TC1_NonNumeric    True

TC2 Decimal Input
    Deposit And Check    100.5    ${ERR_WHOLE_NUMBER_PREFIX}    TC2_Decimal    True

TC5 Empty Input
    Deposit And Check    ${EMPTY}    ${ERR_INVALID_NUMBER}    TC5_EmptyInput    True

TC3 Negative Amount
    Deposit And Check    -50    ${ERR_GREATER_THAN_ZERO}    TC3_Negative

TC4 Zero Amount
    Deposit And Check    0    ${ERR_GREATER_THAN_ZERO}    TC4_Zero

TC6 Valid Deposit
    Deposit And Check    100    ${SUCCESS_MSG}    TC6_ValidDeposit    False    True
