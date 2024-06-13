using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class DetectInputType : MonoBehaviour
{
    public bool usingPs4Controller, usingXboxController, usingKeyboard;
    public static DetectInputType instance;

    void Awake()
    {
        instance = this;
    }

    void Update()
    {
        if (Gamepad.current == null)
        {
            if (usingKeyboard)
            {
                return;
            }
            ResetBool();
            usingKeyboard = true;
        }
        else if (Gamepad.current.name == "DualShock4GamepadHID")
        {
            if(usingPs4Controller)
            {
                return;
            }
            ResetBool();
            usingPs4Controller = true;
        }
        else
        {
            if (usingXboxController)
            {
                return;
            }
            ResetBool();
            usingXboxController = true;
        }
    }

    void ResetBool()
    {
        usingPs4Controller = false;
        usingXboxController = false;
        usingKeyboard = false;
    }
}
