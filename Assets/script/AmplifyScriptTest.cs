using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AmplifyScriptTest : MonoBehaviour {
    public Renderer myRenderer;
    public Transform[] positions;
    public Vector4[] vectorPositions;
    public GameObject[] objects;
    public MaterialPropertyBlock materialProperty;

    bool startDone;

    // Use this for initialization
    void Start()
    {
        startDone = false;
        Invoke("StartContent",Time.deltaTime*10);
    }

    void StartContent()
    {
        //Debug.Log("plop");
        myRenderer = GetComponent<Renderer>();
        materialProperty = new MaterialPropertyBlock();
        objects = GameObject.FindGameObjectsWithTag("ShaderEffect");
        positions = new Transform[objects.Length];
        vectorPositions = new Vector4[objects.Length];
        for (int i = 0; i < objects.Length; i++)
        {
            positions[i] = objects[i].transform;
        }

        startDone = true;
    }

    private void Update()
    {
        if(startDone == false)
        {
            return;
        }

        /*foreach(Transform t in positions)
        {
            Debug.Log(t);
        }*/

        //Debug.Log(""+objects.Length+" "+positions.Length);
        
        for (int i = 0; i < objects.Length; i++)
        {
            vectorPositions[i] = new Vector4(positions[i].position.x, positions[i].position.y, positions[i].position.z, 0);
        }
        materialProperty.SetVectorArray("positionsArray", vectorPositions);
        myRenderer.SetPropertyBlock(materialProperty);
    }
}
