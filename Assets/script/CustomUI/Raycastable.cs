using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Raycastable : MonoBehaviour
{
    public UnityEvent eventOnOver;
    public UnityEvent eventOnOut;
    public UnityEvent eventOnInteract;

    private bool isOver = false;

    public void PerformOnOver()
	{
        if (eventOnOver != null && isOver == false)
        {
            isOver = true;
            eventOnOver.Invoke();
        }
    }

    public void PerformOnOut()
    {
        if (eventOnOut != null && isOver == true)
        {
            isOver = false;
            eventOnOut.Invoke();
        }
    }

    public void PerformOnInteract()
    {
        if (eventOnInteract != null)
        {
            eventOnInteract.Invoke();
        }
    }
}
