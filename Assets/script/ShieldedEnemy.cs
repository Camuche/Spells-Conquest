using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldedEnemy : MonoBehaviour
{

    [SerializeField] GameObject shield;
    public GameObject damageZone;

    // Start is called before the first frame update
    void Start()
    {
        GameObject s = Instantiate(shield);


        if (s.GetComponent<BreakableShield>() != null)
        {
            s.GetComponent<BreakableShield>().parent = gameObject;
        }

        if (s.GetComponent<EnemiFireShield>() != null)
        {
            s.GetComponent<EnemiFireShield>().parent = gameObject;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
