using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class CustomUIElement : MonoBehaviour
{
    public CustomUIElement onRight;
    public CustomUIElement onLeft;
    public CustomUIElement onUp;
    public CustomUIElement onDown;

    public UnityEvent OnConfirm;
    public UnityEvent OnCancel;

    public UnityEvent OnSelect;
    public UnityEvent OnDeselect;

    public void PerformOnSelect()
	{
        OnSelect.Invoke();
    }

    public void PerformOnDeselect()
    {
        OnDeselect.Invoke();
    }
    public void PerformOnConfirm()
    {
        OnConfirm.Invoke();
    }

    public void PerformOnCancel()
    {
        OnCancel.Invoke();
    }

    public void PerformOnLeft()
	{
        if (onLeft == null)
            return;

        CustomUIManager.instance.ChangeSelected(onLeft);
    }

    public void PerformOnRight()
    {
        if (onRight == null)
            return;

        CustomUIManager.instance.ChangeSelected(onRight);
    }
    public void PerformOnUp()
    {
        //Debug.Log("onUp1");

        if (onUp == null)
            return;

        //Debug.Log("onUp2");
        CustomUIManager.instance.ChangeSelected(onUp);
    }

    public void PerformOnDown()
    {
        //Debug.Log("onDown1");

        if (onDown == null)
            return;

        //Debug.Log("onDown2");
        CustomUIManager.instance.ChangeSelected(onDown);
    }
}
