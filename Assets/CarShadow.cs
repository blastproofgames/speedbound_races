using UnityEngine;

public class CarShadow : MonoBehaviour
{
    [SerializeField] private Transform car;

    private Vector3 _offSetRotation;
    private Vector3 _offSet;

    private void Start()
    {
        _offSetRotation = transform.eulerAngles - car.eulerAngles;
        _offSet = transform.position - car.position;
    }
    
    private void Update()
    {
        var angle = car.eulerAngles + _offSetRotation;
        angle.z = 0;
        angle.x = 0;
        transform.eulerAngles = angle;
        transform.position = car.position + _offSet;
    }
}
