﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WorkshopMenu : MonoBehaviour
{
    [SerializeField] Material UiMat;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        GameObject.Find("UI(Clone)").SetActive(Cursor.lockState == CursorLockMode.None? false : true);

    }

    public void Workshop_Environment()
    {
        SceneManager.LoadScene("Workshop_Environment");
    }

    public void Workshop_Arena()
    {
        SceneManager.LoadScene("Workshop_Arena");
    }

    public void Level()
    {
        SceneManager.LoadScene("Level");
        
    }

    public void Menu()
    {
        SceneManager.LoadScene("Menu");
        Cursor.lockState = CursorLockMode.None;
        

        
    }
}
