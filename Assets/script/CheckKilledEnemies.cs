using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class CheckKilledEnemies : MonoBehaviour
{
    public GameObject enemy;
    //public GameObject puzzleLogique;
    //public int conditionIndex;
    bool isDead = false;

    public UnityEvent eventOnTrue;
    public UnityEvent eventOnFalse;

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
            eventOnFalse.Invoke();
            //Debug.Log("Alive");
        }
        else
        {
            //Debug.Log("Dead");
            isDead = true;
            eventOnTrue.Invoke();
            //SetCondition();
        }
    }

    /*void SetCondition()
    {
        puzzleLogique.GetComponent<PuzzleLogique>().conditions[conditionIndex] = true;

    }*/
}



