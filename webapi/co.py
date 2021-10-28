import serial,time

class get_co_data:
    def __init__(self, device='/dev/ttyS0', baudrate=9600, timeout=1):
        self.ser = serial.Serial(device, baudrate=baudrate, timeout=timeout)
        self.ser.flush()
    def repeat_get_data(self):
        while True:
            if self.ser.in_waiting > 0:
                line = self.ser.readline().decode('utf-8').rstrip()
                items = [it.strip() for it in line.split("|")]
                items = [it for it in items if it!=""]
                if len(items)==9:
                    items = dict(zip(
                        ['ADC_In', 'Equation_V_ADC', 'Voltage_ADC', 'Equation_RS', 'Resistance_RS', 'EQ_Ratio', 'Ratio (RS/R0)', 'Equation_PPM', 'PPM'],
                        items
                    ))
                    items['time'] = time.ctime()
                    items['timestamp'] = time.time()
                    items['orig_line'] = line
                    yield items
                else:
                    continue

if __name__ == '__main__':
    getco = get_co_data()
    data = getco.repeat_get_data()
    for i in range(10):
        f = next(data)
        print(f)