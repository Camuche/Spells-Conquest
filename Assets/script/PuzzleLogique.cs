using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class PuzzleLogique : MonoBehaviour
{
    public UnityEvent eventOnTrue;
    public UnityEvent eventOnFalse;

    public bool[] conditions;

    private int i;

    public enum portesLogiques {AND, OR};
    public portesLogiques typeDeCondition = portesLogiques.AND;

    public void SetConditionTrue(int index)
	{
        conditions[index] = true;

        //CheckConditions();
    }

    public void SetConditionFalse(int index)
    {
        conditions[index] = false;

        //CheckConditions();
    }

    public void SwitchCondition(int index)
	{
        conditions[index] = !conditions[index];

        //CheckConditions();
    }

    public void CheckConditions()
	{
        if(typeDeCondition == portesLogiques.AND)
		{
            if(CheckANDConditions())
			{
                eventOnTrue.Invoke();
            }
            else
			{
                eventOnFalse.Invoke();
			}
        }

        if (typeDeCondition == portesLogiques.OR)
        {
            if (CheckORConditions())
            {
                eventOnTrue.Invoke();
            }
            else
            {
                eventOnFalse.Invoke();
            }
        }
    }

    bool CheckANDConditions()
	{
        for(i=0; i<conditions.Length;i++)
		{
            if(conditions[i] == false)
			{
                return false;
			}
		}

        return true;
	}

    bool CheckORConditions()
    {
        for (i = 0; i < conditions.Length; i++)
        {
            if (conditions[i] == true)
            {
                return true;
            }
        }

        return false;
    }
}
