using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gem : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
	{
		transform.Rotate(0,5f,0,Space.World);
	}

	private void OnTriggerEnter(Collider other)
	{
		other.transform.parent.GetComponent<HeliController>().PickupCoin(5);
		Destroy(gameObject);
	}
}
