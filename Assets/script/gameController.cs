﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gameController : MonoBehaviour
{

    [SerializeField] Material matLave;

    GameObject player;

    [HideInInspector]public Vector3 CheckPoint;

    private void OnLevelWasLoaded(int level)
    {

        matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));


        player = GameObject.Find("Player");
        if (CheckPoint != Vector3.zero)
        {
            player.transform.position = CheckPoint;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
      



    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
