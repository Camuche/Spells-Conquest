using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class PuzzleTriggerForBiomeDetection : MonoBehaviour
{
	//L'objet sur lequel vous placez ce script doit etre un trigger
	public string[] tagsAndNamesToCheck;

	public UnityEvent eventOnEnter;

	private int i;

	[HideInInspector] public static int currentBiome = 1;
	public int triggerBiomeNumber;


    private void OnTriggerEnter(Collider other)
	{
		if (CheckTagAndName(other.gameObject))
		{
			if (!CheckBiomeShift(triggerBiomeNumber))
			{
				return;
			}
			eventOnEnter.Invoke();
		}
	}


	bool CheckTagAndName(GameObject toBeChecked)
	{
		if (tagsAndNamesToCheck.Length == 0)
		{
			return true;
		}

		for (i = 0; i < tagsAndNamesToCheck.Length; i++)
		{
			if (toBeChecked.name == tagsAndNamesToCheck[i] || toBeChecked.tag == tagsAndNamesToCheck[i])
			{
				return true;
			}
		}

		return false;
	}

	bool CheckBiomeShift(int biomeNumber)
    {
		if (currentBiome != biomeNumber)
        {
			currentBiome = biomeNumber;
			return true;
        }

		return false;
    }
}
