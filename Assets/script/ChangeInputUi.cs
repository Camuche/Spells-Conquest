using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeInputUi : MonoBehaviour
{
    bool keyboardInput, playstationInput, xboxInput;

    public GameObject switchSpellL, switchSpellR;
    public Texture keyboardA, keyboardE;
    public Texture playstationL1, playstationR1;
    public Texture xboxLb, xboxRb;


    void Update()
    {
        if (DetectInputType.instance.usingKeyboard)
        {
            if (keyboardInput)
            {
                return;
            }

            ResetBool();
            keyboardInput = true;

            switchSpellL.GetComponent<MeshRenderer>().material.SetTexture("_MainTex", keyboardA);
            switchSpellR.GetComponent<MeshRenderer>().material.SetTexture("_MainTex", keyboardE);
        }

        else if (DetectInputType.instance.usingPs4Controller)
        {
            if (playstationInput)
            {
                return;
            }

            ResetBool();
            playstationInput = true;

            switchSpellL.GetComponent<MeshRenderer>().material.SetTexture("_MainTex", playstationL1);
            switchSpellR.GetComponent<MeshRenderer>().material.SetTexture("_MainTex", playstationR1);
        }

        else if (DetectInputType.instance.usingXboxController)
        {
            if (xboxInput)
            {
                return;
            }

            ResetBool();
            xboxInput = true;

            switchSpellL.GetComponent<MeshRenderer>().material.SetTexture("_MainTex", xboxLb);
            switchSpellR.GetComponent<MeshRenderer>().material.SetTexture("_MainTex", xboxRb);
        }
    }

    void ResetBool()
    {
        keyboardInput = false;
        playstationInput = false;
        xboxInput = false;
    }
}
