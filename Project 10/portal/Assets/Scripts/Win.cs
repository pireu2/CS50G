using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Win : MonoBehaviour {
    public Text winText;

	// Use this for initialization
	void Start()
	{
		winText.color = Color.clear;
	}

	// Update is called once per frame
	void Update () {
		if (winText.color == Color.black && Input.GetKeyDown(KeyCode.Space))
		{
			SceneManager.LoadScene("Play");
		}
	}

	private void OnTriggerEnter(Collider other)
	{
		winText.color = Color.black;
	}
}
