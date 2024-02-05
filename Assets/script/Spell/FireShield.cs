using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireShield : MonoBehaviour
{

    [SerializeField] Collider IngoreCol;
    public float timeBeforeScaling, speed;
    bool isScaling;
    float time, currentScale;

    // Start is called before the first frame update
    void Start()
    {
        transform.localScale = new Vector3 (0,0,0);
        Invoke("ScaleGO", timeBeforeScaling);
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

        if(isScaling && currentScale <= 0.18f)
        {
            /*time += Time.deltaTime;
            float currentScale = */
            currentScale += 0.01f * speed;
            transform.localScale = new Vector3(currentScale,currentScale,currentScale);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("enemiBullet"))
        {
            
            Destroy(other.gameObject);
        }
    }

    void ScaleGO()
    {
        isScaling = true;
    }

    
}
