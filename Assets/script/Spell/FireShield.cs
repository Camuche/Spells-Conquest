using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireShield : MonoBehaviour
{

    [SerializeField] Collider IngoreCol;
    public float timeBeforeScaling, timeBeforeUnscale, speed, dissolveSpeed, delayDecalTrail;
    bool isScaling, isUnscaling;
    float time, currentScale;
    public Material material, particleSystemMat;
    float particleSystemAlpha;
    public GameObject decalTrailGO;

    // Start is called before the first frame update
    void Start()
    {
        transform.localScale = new Vector3 (0,0,0);
        Invoke("ScaleGO", timeBeforeScaling);
        Invoke("Unscale", timeBeforeUnscale);
        material.SetFloat("_Dissolve", 1);
        particleSystemAlpha = 1;
        particleSystemMat.color = new Vector4 (1,1,1,particleSystemAlpha);
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
        else if (isScaling && currentScale > 0.18f)
        {
            isScaling = false;
        }

        if (isUnscaling)
        {
            material.SetFloat("_Dissolve", material.GetFloat("_Dissolve")- 0.01f * dissolveSpeed);
            
            
            if(particleSystemAlpha > 0)
            {
                particleSystemAlpha -= 0.01f * dissolveSpeed;
            }
            else if (particleSystemAlpha <= 0)
            {
                particleSystemAlpha = 0;
            }
            
            particleSystemMat.color = new Vector4(1,1,1,particleSystemAlpha);
        }

        if (timeStart == true)
        {
            time += Time.deltaTime;
        }

        if (time >= delayDecalTrail)
        {
            Instantiate(decalTrailGO, transform.position, Quaternion.Euler(transform.rotation.x, Random.Range(0,360), transform.rotation.z) , null);
            time = 0;
        }
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("enemiBullet"))
        {
            
            Destroy(other.gameObject);
        }
    }

    bool timeStart;
    void ScaleGO()
    {
        isScaling = true;
        timeStart = true;
    }

    void Unscale()
    {
        isUnscaling = true;
    }

    
}
