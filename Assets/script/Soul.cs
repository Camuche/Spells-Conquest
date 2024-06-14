using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class Soul : MonoBehaviour
{


    [HideInInspector] public int soulMoney;
    [SerializeField] private GameObject money;

    bool isFading;
    public float opacity, timeToFade;
    public GameObject characterGO, landmarkGO;

    AudioSource audioSource;
    public AudioClip spawnSoulClip, soulClip, absorbSoulClip;



    // Start is called before the first frame update
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        audioSource.PlayOneShot(spawnSoulClip);
    }

    // Update is called once per frame
    void Update()
    {
        if (!audioSource.isPlaying)
        {
            audioSource.PlayOneShot(soulClip);
        }

        if(isFading)
        {
            opacity -= Time.deltaTime / timeToFade;
            characterGO.GetComponent<MeshRenderer>().material.SetFloat("_Opacity", opacity);
            landmarkGO.GetComponent<MeshRenderer>().material.SetFloat("_Opacity", opacity);

            if (opacity <= 0)
            {
                opacity = 0;
                isFading = false;
            }
        }
        
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            if (PlayerController.instance.isDead)
            {
                return;
            }
            isFading = true;

            audioSource.PlayOneShot(absorbSoulClip);

            for (int i=0; i < soulMoney; i++)
            {
                Instantiate(money, transform.position + new Vector3(Random.Range(-1f,1f),.5f,Random.Range(-1f,1f)), transform.rotation * Quaternion.Euler(0,Random.Range(-180f,180f),0));
            }
            Destroy(gameObject, 1);
        }
    }
}
