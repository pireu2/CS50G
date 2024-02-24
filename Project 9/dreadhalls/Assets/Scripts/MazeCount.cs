using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MazeCount : MonoBehaviour
{
	private static int mazeCount = 0;
	private Text text;

	// Use this for initialization
	void Start ()
	{
		text = gameObject.GetComponent<Text>();
	}

	public static void Initialize()
	{
		mazeCount = 0;
	}
	public static void Increment()
	{
		mazeCount++;
	}

	// Update is called once per frame
	void Update () {
		text.text = "Mazes: " + mazeCount;
	}
}
