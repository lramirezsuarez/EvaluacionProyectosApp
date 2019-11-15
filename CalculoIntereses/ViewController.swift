//
//  ViewController.swift
//  CalculoIntereses
//
//  Created by Luis Alejandro Ramirez on 11/15/19.
//  Copyright © 2019 Luis Alejandro Ramirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipoIntereses: UISegmentedControl!
    @IBOutlet weak var valorPresenteTextField: UITextField!
    @IBOutlet weak var valorFuturoTextField: UITextField!
    @IBOutlet weak var interesTextField: UITextField!
    @IBOutlet weak var periodosTextField: UITextField!
    
    @IBAction func calcularIntereses(_ sender: Any) {
        guard let valorPresenteString = valorPresenteTextField.text,
            let valorFuturoString = valorFuturoTextField.text,
            let interesesString = interesTextField.text,
            let periodosString = periodosTextField.text else {
                return
        }
        checkDoubleValues(vpString: valorPresenteString,
                          vfString: valorFuturoString,
                          iString: interesesString,
                          pString: periodosString)
    }
    
    @IBAction func limpiarValores(_ sender: Any) {
        valorPresenteTextField.text = ""
        valorFuturoTextField.text = ""
        interesTextField.text = ""
        periodosTextField.text = ""
        resetearValores()
    }
    
    private var alreadyShowingAlert = false
    private var valorPresente = 0.0
    private var valorFuturo = 0.0
    private var intereses = 0.0
    private var periodos = 0.0

    private let numberFormmatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormmatter.numberStyle = .decimal
    }
    
    private func checkDoubleValues(vpString: String, vfString: String, iString: String, pString: String) {
        if vpString == "" && vfString == "" && iString == "" && pString == "" {
            presentAlert("Tienes que escribir un numero en alguno de los campos requeridos.")
            return
        }
        if let vpNumber = numberFormmatter.number(from: vpString), let doubleValorPresente = Double(exactly: vpNumber) {
            valorPresente = doubleValorPresente
        } else if vpString != "" {
            presentAlert("Tienes que escribir un numero para el valor presente.")
            return
        }
        
        if let vfNumber = numberFormmatter.number(from: vfString), let doubleValorFuturo = Double(exactly: vfNumber) {
            valorFuturo = doubleValorFuturo
        } else if vfString != "" {
            presentAlert("Tienes que escribir un numero para el valor futuro.")
            return
        }
        
        if let interesesNumber = numberFormmatter.number(from: iString), let doubleIntereses = Double(exactly: interesesNumber) {
            intereses = doubleIntereses
        } else if iString != "" {
            presentAlert("Tienes que escribir un numero para los intereses.")
            return
        }
        
        if let periodosNumber = numberFormmatter.number(from: pString), let doublePeriodos = Double(exactly: periodosNumber) {
            periodos = doublePeriodos
        } else if pString != "" {
            presentAlert("Tienes que escribir un numero para los periodos.")
            return
        }
        calcularIntereses()
    }
    
    private func presentAlert(_ message: String) {
        guard !alreadyShowingAlert else {
            return
        }
        alreadyShowingAlert = true
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            self.alreadyShowingAlert = false
        })
        alert.addAction(okayAction)
        present(alert, animated: true)
    }

    private func calcularIntereses() {
        switch tipoIntereses.selectedSegmentIndex {
        case 0:
            if valorPresente == 0.0 && valorFuturo != 0.0 && periodos != 0.0 && intereses != 0.0 {
                valorPresenteTextField.text = numberFormmatter.string(from: NSNumber(value: calcularValorPresenteSimple(vf: valorFuturo, n: periodos, i: intereses)))
            } else if valorFuturo == 0.0 && valorPresente != 0.0 && periodos != 0.0 && intereses != 0.0 {
                valorFuturoTextField.text = numberFormmatter.string(from: NSNumber(value: calcularValorFuturoSimple(vp: valorPresente, n: periodos, i: intereses)))
            } else if intereses == 0.0 && valorPresente != 0.0 && periodos != 0.0 && valorFuturo != 0.0 {
                interesTextField.text = numberFormmatter.string(from: NSNumber(value: calcularInteresesSimple(vf: valorFuturo, vp: valorPresente, n: periodos)))
            } else if periodos == 0.0 && valorPresente != 0.0 && valorFuturo != 0.0 && intereses != 0.0 {
                periodosTextField.text = numberFormmatter.string(from: NSNumber(value: calcularPeriodosSimple(vf: valorFuturo, vp: valorPresente, i: intereses)))
            } else {
                presentAlert("Debe ingresar al menos 3 valores en alguno de los campos para calcular el campo que necesitas.")
            }
            resetearValores()
        case 1:
            if valorFuturo == 0.0 && valorPresente != 0.0 && periodos != 0.0 && intereses != 0.0 {
                valorFuturoTextField.text = numberFormmatter.string(from: NSNumber(value: calcularValorFuturoCompuesto(vp: valorPresente, n: periodos, i: intereses)))
            } else if valorPresente == 0.0 && valorFuturo != 0.0 && periodos != 0.0 && intereses != 0.0 {
                valorPresenteTextField.text = numberFormmatter.string(from: NSNumber(value: calcularValorPresenteCompuesto(vf: valorFuturo, n: periodos, i: intereses)))
            } else if intereses == 0.0 && valorPresente != 0.0 && periodos != 0.0 && valorFuturo != 0.0 {
                interesTextField.text = numberFormmatter.string(from: NSNumber(value: calcularInteresesCompuesto(vf: valorFuturo, vp: valorPresente, n: periodos)))
            } else if periodos == 0.0 && valorPresente != 0.0 && valorFuturo != 0.0 && intereses != 0.0 {
                periodosTextField.text = numberFormmatter.string(from: NSNumber(value: calcularPeriodosCompuesto(vf: valorFuturo, vp: valorPresente, i: intereses)))
            } else {
                presentAlert("Debe ingresar al menos 3 valores en alguno de los campos para calcular el campo que necesitas.")
            }
            resetearValores()
        default:
            presentAlert("Error inesperado en el calculo, informale al desarrollador.")
            break
        }
    }
    
    private func resetearValores() {
        valorFuturo = 0.0
        valorPresente = 0.0
        intereses = 0.0
        periodos = 0.0
    }
    
    // MARK: Calculos para el Interes Simple
    private func calcularValorFuturoSimple(vp: Double, n: Double, i: Double) -> Double {
        return vp * (1 + n * i)
    }
    
    private func calcularValorPresenteSimple(vf: Double, n: Double, i: Double) -> Double {
        return vf / (1 + n * i)
    }
    
    private func calcularInteresesSimple(vf: Double, vp: Double, n: Double) -> Double {
        return ((vf / vp) - 1) * (1 / n)
    }
    
    private func calcularPeriodosSimple(vf: Double, vp: Double, i: Double) -> Double {
        return ((vf / vp) - 1) * (1 / i)
    }
    
    // MARK: Calculos para el Interes Compuesto
    private func calcularValorFuturoCompuesto(vp: Double, n: Double, i: Double) -> Double {
        return vp * pow((1 + i), n)
    }
    
    private func calcularValorPresenteCompuesto(vf: Double, n: Double, i: Double) -> Double {
        return vf / pow((1 + i), n)
    }
    
    private func calcularInteresesCompuesto(vf: Double, vp: Double, n: Double) -> Double {
        return pow((vf / vp), 1 / n) - 1
    }
    
    private func calcularPeriodosCompuesto(vf: Double, vp: Double, i: Double) -> Double {
        return log(vf / vp) / log(1 + i)
    }
}
