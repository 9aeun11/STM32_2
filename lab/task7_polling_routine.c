/* 과제7: 이 함수 본문을 Core/Src/ece2_474_routine.c의 polling_routine으로 교체합니다.
 * FPGA가 '0'/'1'/'2' 명령으로 지정 LED를 제어하도록 구성한 뒤 사용합니다.
 */
void polling_routine(void)
{
    int ch = getchar();
    if (ch != EOF)
    {
        uint8_t data = (uint8_t)ch;
        HAL_StatusTypeDef result =
            HAL_UART_Transmit(&huart3, &data, 1U, 100U);
        printf("보낸 문자: %c, 값: 0x%02X, 전송 결과: %d\r\n",
               ch, (unsigned int)data, (int)result);
    }
}
