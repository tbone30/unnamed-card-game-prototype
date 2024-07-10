using System.Collections.Generic;
using UnityEngine;
using tbone;

public class ArcRenderer : MonoBehaviour
{
    public GameObject arrowPrefab;
    public GameObject dotPrefab;
    public int poolSize = 50; //size of the dot pool- pool being a group of objects that are reused
    private List<GameObject> dotPool = new List<GameObject>();
    private GameObject arrowInstance;

    public float spacing = 40; //spacing between dots
    public float arrowAngleAdjustment = 180;
    public int dotsToSkip = 2; //skip dots to give the arrowhead space
    private Vector3 arrowDirection;
    
    void Start()
    {
        arrowInstance = Instantiate(arrowPrefab, transform);
        arrowInstance.transform.localPosition = Vector3.zero;
        InitializeDotPoll(poolSize);
    }

    void Update()
    {
        Vector3 mousePos = Input.mousePosition;
        mousePos.z = 0;

        Vector3 startPos = transform.position;
        Vector3 midPoint = CalculateMidPoint(startPos, mousePos);

        UpdateArc(startPos, midPoint, mousePos);
        PositionAndRotateArrow(mousePos);
    }

    void UpdateArc(Vector3 startPos, Vector3 midPoint, Vector3 endPos)
    {
        int numDots = Mathf.CeilToInt(Vector3.Distance(startPos, endPos) / spacing);

        for(int i = 0; i < numDots && i < dotPool.Count; i++)
        {
            float t = i / (float) numDots;
            t = Mathf.Clamp(t, 0f, 1f);

            Vector3 position = QuadraticBezierPoint(startPos, midPoint, endPos, t);

            if(i != numDots - dotsToSkip)
            {
                dotPool[i].transform.position = position;
                dotPool[i].SetActive(true);
            }
            if(i == numDots - (dotsToSkip + 1) && i - dotsToSkip + 1 >= 0)
            {
                arrowDirection = dotPool[i].transform.position; 
            }
        }

        //deactivate unused dots
        for(int i = numDots - dotsToSkip; i < dotPool.Count; i++)
        {
            if(i > 0)
            {
                dotPool[i].SetActive(false);
            }
        }
    }

    void PositionAndRotateArrow(Vector3 endPos)
    {
        arrowInstance.transform.position = endPos;
        Vector3 direction = arrowDirection - endPos;
        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;
        arrowInstance.transform.rotation = Quaternion.AngleAxis(angle + arrowAngleAdjustment, Vector3.forward); //forward is (0, 0, 1) aka rotating about the z axis- bc its in 2d
    }

    Vector3 CalculateMidPoint(Vector3 startPos, Vector3 endPos)
    {
        Vector3 midPoint = (startPos + endPos) / 2;
        midPoint.y += (Vector3.Distance(startPos, endPos) / 3f); 
        return midPoint;
    }

    Vector3 QuadraticBezierPoint(Vector3 start, Vector3 mid, Vector3 end, float t)
    {
        float u = 1 - t;
        float tt = t * t;
        float uu = u * u;

        Vector3 point = uu * start;
        point += 2 * u * t * mid;
        point += tt * end;

        return point;
    }

    void InitializeDotPoll(int size)
    {
        for (int i = 0; i < size; i++)
        {
            GameObject dot = Instantiate(dotPrefab, Vector3.zero, Quaternion.identity, transform);
            dot.SetActive(false);
            dotPool.Add(dot);
        }
    }
}
