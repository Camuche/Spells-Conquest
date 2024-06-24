using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class Credit : MonoBehaviour
{
    GameObject creditGO;

    // Start is called before the first frame update
    void Start()
    {
        creditGO = GameObject.Find("Prefab_Credit");
        creditGO.GetComponent<MeshRenderer>().enabled = false;
        creditGO.GetComponent<VideoPlayer>().enabled = false;
    }

    
    public void PlayCredit()
    {
        creditGO = GameObject.Find("Prefab_Credit");
        creditGO.GetComponent<MeshRenderer>().enabled = true;
        creditGO.GetComponent<VideoPlayer>().enabled = true;
    }
}
