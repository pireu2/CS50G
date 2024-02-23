using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scrollable : MonoBehaviour {
	public static float Speed = 10f;
	public float Multiplier = 1f;

	// Use this for initialization
	void Start ()
	{
		StartCoroutine(IncreaseSpeed());
	}
	
	// Update is called once per frame
	void Update () {
		if (transform.position.x < -25) {
			Destroy(gameObject);
		}
		else {

			// ensure coin moves at the same rate as the skyscrapers do
			transform.Translate(-Speed * Multiplier * Time.deltaTime, 0, 0, Space.World);
		}
	}
	
	IEnumerator IncreaseSpeed()
	{
		while (true)
		{
			if (Random.Range(1, 4) == 1) {
				Speed += 1f;
			}
			yield return new WaitForSeconds(Random.Range(1, 5));
		}
	}
}
