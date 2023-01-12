﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireballTorch : MonoBehaviour
{
    Renderer fireRenderer;
    public Material green;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Fireball")
        {
            fireRenderer = GetComponent<Renderer>();
            fireRenderer.material.CopyPropertiesFromMaterial(green);

            foreach (Transform child in transform)
            {
                child.gameObject.SetActive(true);
            }
        }
    }
}
