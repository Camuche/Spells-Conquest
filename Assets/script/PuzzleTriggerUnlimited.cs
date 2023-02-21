using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class PuzzleTriggerUnlimited : MonoBehaviour
{
	//L'objet sur lequel vous placez ce script doit etre un trigger
	public string[] tagsAndNamesToCheck;

	public UnityEvent eventOnEnter;
	public UnityEvent eventOnExit;

	public int numberInTrigger = 0;
	private int i;

	private void OnTriggerEnter(Collider other)
	{
		if(CheckTagAndName(other.gameObject))
		{
			
			eventOnEnter.Invoke();
			
		}
	}

	private void OnTriggerExit(Collider other)
	{
		if (CheckTagAndName(other.gameObject))
		{

			eventOnExit.Invoke();
			
		}
	}

	bool CheckTagAndName(GameObject toBeChecked)
	{
		if(tagsAndNamesToCheck.Length == 0)
		{
			return true;
		}

		for(i = 0; i<tagsAndNamesToCheck.Length; i++)
		{
			if(toBeChecked.name == tagsAndNamesToCheck[i] || toBeChecked.tag == tagsAndNamesToCheck[i])
			{
				return true;
			}
		}

		return false;
	}
}
