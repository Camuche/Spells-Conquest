using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayInput : MonoBehaviour
{
    public static DisplayInput instance;
    public static bool instanceExist;

    bool keyboardInput, playstationInput, xboxInput;
    [HideInInspector] public bool displayInteract, displayLockMode;

    public Texture keyboardF, keyboardR;
    public Texture playstationX, playstationTriangle;
    public Texture xboxA, xboxY;

    private void Awake()
    {
        if(!instanceExist)
        {
            instance = this;
            instanceExist = true;
        }
        
    }

    private void Start()
    {
        displayInteract = true;
    }

    void Update()
    {
        if (GetComponent<MeshRenderer>().enabled == true)
        {
            if (DetectInputType.instance.usingKeyboard)
            {
                if (displayInteract)
                {
                    GetComponent<MeshRenderer>().material.SetTexture("_MainTex", keyboardF);
                }
                else if (displayLockMode)
                {
                    GetComponent<MeshRenderer>().material.SetTexture("_MainTex", keyboardR);
                }


                if (keyboardInput)
                {
                    return;
                }

                ResetBool();
                keyboardInput = true;
            }


            else if (DetectInputType.instance.usingPs4Controller)
            {
                if (displayInteract)
                {
                    GetComponent<MeshRenderer>().material.SetTexture("_MainTex", playstationX);
                }
                else if (displayLockMode)
                {
                    GetComponent<MeshRenderer>().material.SetTexture("_MainTex", playstationTriangle);
                }


                if (playstationInput)
                {
                    return;
                }

                ResetBool();
                playstationInput = true;
            }



            else if (DetectInputType.instance.usingXboxController)
            {
                if (displayInteract)
                {
                    GetComponent<MeshRenderer>().material.SetTexture("_MainTex", xboxA);
                }
                else if (displayLockMode)
                {
                    GetComponent<MeshRenderer>().material.SetTexture("_MainTex", xboxY);
                }


                if (xboxInput)
                {
                    return;
                }

                ResetBool();
                xboxInput = true;
            }
        }
    }

    public void HideInput()
    {
        displayInteract = false;
        displayLockMode = false;
        GetComponent<MeshRenderer>().enabled = false;
    }

    public void InteractInput()
    {
        displayInteract = true;
        GetComponent<MeshRenderer>().enabled = true;
    }

    public void LockModeInput()
    {
        displayLockMode = true;
        GetComponent<MeshRenderer>().enabled = true;
    }


    void ResetBool()
    {
        keyboardInput = false;
        playstationInput = false;
        xboxInput = false;
    }
}
