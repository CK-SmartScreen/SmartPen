import UIKit

class GroupPickerViewModel: UIPickerView {
    var groupArray:[String] = []
    var selectedRow = ""
    func setOptionArray (_ groupArray: [String]){
        self.groupArray = groupArray
    }
}
extension GroupPickerViewModel: UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupArray.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = groupArray[row]
    }
}

extension GroupPickerViewModel: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return groupArray[row]
    }
}
