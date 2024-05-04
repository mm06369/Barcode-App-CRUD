from pyzbar import pyzbar
import cv2

def read_barcodes():
    cap = cv2.VideoCapture(0)
    while True:
        _, frame = cap.read()
        barcodes = pyzbar.decode(frame)
        for barcode in barcodes:
            barcode_data = barcode.data.decode("utf-8")
            print("Barcode data:", barcode_data)
        cv2.imshow("Barcode Scanner", frame)
        key = cv2.waitKey(1)
        if key == 27:
            break
    cap.release()
    cv2.destroyAllWindows()

# if __name__ == "__main__":
#     read_barcodes()