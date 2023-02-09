using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gameController : MonoBehaviour
{

    public Material matLave;

    // Start is called before the first frame update
    void Start()
    {
        matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
