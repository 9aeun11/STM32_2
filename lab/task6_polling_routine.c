/* 과제6: 이 함수 본문을 Core/Src/ece2_474_routine.c의 polling_routine으로 교체합니다.
 * FPGA 수신 UART와 GND를 연결한 뒤 사용합니다. UART3(PC10 TX)는 교안 설정을 사용합니다.
 */
void polling_routine(void)
{
    int ch = getchar();
    if (ch != EOF)
    {
        uint8_t data = (uint8_t)ch;
        HAL_StatusTypeDef result =
            HAL_UART_Transmit(&huart3, &data, 1U, 100U);
        printf("전송 결과: %d\r\n", (int)result);
    }
}
