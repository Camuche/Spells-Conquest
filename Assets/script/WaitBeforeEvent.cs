using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class WaitBeforeEvent : MonoBehaviour
{

    private float timer;
    public float endTime;

    public UnityEvent OnTimerEnd;

    public bool timerOn = false;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
		if (timerOn == false)
		{
            return;
		}

        timer += Time.deltaTime;

        if (timer > endTime)
        {
            OnTimerEnd.Invoke();
            //enabled = false;
            timerOn = false;
        }
    }

    public void StartTimer()
	{
        timerOn = true;
        ResetTimer();
    }

    public void ResetTimer()
    {
        timer = 0;
    }
}
