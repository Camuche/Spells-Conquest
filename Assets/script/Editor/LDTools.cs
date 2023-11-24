using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class LDTools 
{
    [MenuItem("LD Tools/Snap Position")]
	static void SnapPosition()
	{
		Undo.RecordObjects(Selection.gameObjects, "SnapPosition");
		foreach (GameObject go in Selection.gameObjects)
		{
			go.transform.position = new Vector3(Mathf.Round(go.transform.position.x),Mathf.Round(go.transform.position.y),Mathf.Round(go.transform.position.z));
		}
	}
}
