using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BreakableShield : MonoBehaviour
{
    [HideInInspector]public GameObject parent;
    [SerializeField]float life;

    bool onWave = false;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = parent.transform.position;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("WaterWave"))
        {
            onWave = true;

            
        }
        else if(onWave && other.gameObject.layer == LayerMask.NameToLayer("Wall"))
        {
            life--;
            if (life <= 0)
            {
                parent.GetComponent<ShieldedEnemy>().damageZone.SetActive(true);
                Destroy(gameObject);
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.GetComponent<Wave>() != null)
        {
            onWave = false;
        }
    }
}
