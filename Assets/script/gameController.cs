using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gameController : MonoBehaviour
{

    [SerializeField] Material matLave;


    [HideInInspector]public Vector3 CheckPoint;

    

        // Start is called before the first frame update
        void Start()
        {
            matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));
            //CheckPoint = Player.transform.position;


        }

    // Update is called once per frame
    void Update()
    {
        
    }
}
