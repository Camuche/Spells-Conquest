using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireShield : MonoBehaviour
{

    [SerializeField] Collider IngoreCol;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (GameObject.Find("Player"))
        {
            Physics.IgnoreCollision(IngoreCol, GameObject.Find("Player").GetComponent<CapsuleCollider>());
            Physics.IgnoreCollision(IngoreCol, GameObject.Find("Player").GetComponent<CharacterController>());
        }

        if (GameObject.Find("PrefabFireball(Clone)"))
        {
            Physics.IgnoreCollision(IngoreCol, GameObject.Find("PrefabFireball(Clone)").GetComponent<SphereCollider>());
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("enemiBullet"))
        {
            
            Destroy(other.gameObject);
        }
    }

    
}
