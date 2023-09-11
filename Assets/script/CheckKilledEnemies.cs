using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckKilledEnemies : MonoBehaviour
{
    public GameObject enemy;
    public GameObject puzzleLogique;
    public int conditionIndex;
    bool isDead = false; 

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (isDead == false) Check();
    }

    void Check()
    {
        if (enemy != null)
        {
            //Debug.Log("Alive");
        }
        else
        {
            //Debug.Log("Dead");
            isDead = true;
            SetCondition();
        }
    }

    void SetCondition()
    {
        puzzleLogique.GetComponent<PuzzleLogique>().conditions[conditionIndex] = true;
    }
}



