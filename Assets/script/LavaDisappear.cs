using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LavaDisappear : MonoBehaviour
{
    [SerializeField] GameObject Shield;
    Vector3 shieldPos;
    [SerializeField] Material lava, lavafall;
   


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        Shield = GameObject.Find("PrefabFireShield(Clone)");

        if (Shield != null)
        {
            shieldPos = Shield.transform.Find("shield").transform.position;

            lava.SetVector("_SpherePosition", shieldPos);
            lavafall.SetVector("_SpherePosition", shieldPos);

        }
      
       

    }
}
