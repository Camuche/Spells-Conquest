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
        s.GetComponent<BreakableShield>().parent = gameObject;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
