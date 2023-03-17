using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IgnoreLava : MonoBehaviour
{

    [SerializeField] bool needShield;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (!needShield || (needShield && transform.Find("EnemiFireShield(Clone)") != null))
        {
            Ignore();
        }

        if ((needShield && transform.Find("EnemiFireShield(Clone)") == null))
        {
            StopIgnore();
        }

    }

    void Ignore()
    {
        if (GameObject.FindGameObjectsWithTag("Lava").Length>0)
        {
            for (int i = 0; i < GameObject.FindGameObjectsWithTag("Lava").Length; i++)
            {
                Physics.IgnoreCollision(GameObject.FindGameObjectsWithTag("Lava")[i].GetComponent<Collider>(), GetComponent<Collider>());
            }
        }
    }

    void StopIgnore()
    {
        if (GameObject.FindGameObjectsWithTag("Lava").Length>0)
        {
            for (int i = 0; i < GameObject.FindGameObjectsWithTag("Lava").Length; i++)
            {
                Physics.IgnoreCollision(GameObject.FindGameObjectsWithTag("Lava")[i].GetComponent<Collider>(), GetComponent<Collider>(),false);
            }
        }
    }
}
