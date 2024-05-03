using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EventOnEvent : MonoBehaviour
{
    public UnityEvent myEvent00;
	public UnityEvent myEvent01;

	private int lastEvent = 0;

	public void PerformEvent(int index)
	{
		if (index == 0)
		{
			myEvent00.Invoke();
		}
		else if (index == 1)
		{
			myEvent01.Invoke();
		}
	}

	public void PerformOtherEvent()
	{
		if (lastEvent == 0)
		{
			myEvent00.Invoke();
			lastEvent = 1;
		}
		else if (lastEvent == 1)
		{
			myEvent01.Invoke();
			lastEvent = 0;
		}
	}

}
