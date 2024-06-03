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
            Debug.Log("Using Keyboard");
        }
        else if (Gamepad.current.name == "DualShock4GamepadHID")
        {
            if(usingPs4Controller)
            {
                return;
            }
            ResetBool();
            usingPs4Controller = true;
            Debug.Log("Using PlayStation Controller");
        }
        else
        {
            if (usingXboxController)
            {
                return;
            }
            ResetBool();
            usingXboxController = true;
            Debug.Log("Using Xbox Controller");
        }
    }

    void ResetBool()
    {
        usingPs4Controller = false;
        usingXboxController = false;
        usingKeyboard = false;
    }
}
